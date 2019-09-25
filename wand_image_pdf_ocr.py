# coding=utf-8
# install library
# pip install wand
# yum -y install ImageMagick-devel
# description
# used wand convert pdf to image
# used Image library process image
# send to baidu ocr
from __future__ import division

import StringIO
import math
from wand.image import Image
# 這裡我起了個別名
from PIL import Image as PImage

# 百度OCR最大長度
bai_du_ocr_max = 4096

#主要方法
def convert(file_name, target_width=1500):
   try:
       with Image(filename=file_name) as img:
           image_page_num = len(img.sequence)

           # PDF裡面只有一張圖片
           if image_page_num == 1:
               # 獲取最終圖片寬高
               target_width, target_height = _get_one_info(target_width, img.width, img.height)

               # 縮放，文件上說比resize速度快
               img.sample(target_width, target_height)

               # 如果最終高度大於百度最大高度，則crop
               if target_height > bai_du_ocr_max:
                   img.crop(0, 0, target_width, bai_du_ocr_max)

               # img.save(filename='%s.jpg' % (str(int(time.time())) + '_' + str(img.width)))
               result = img.make_blob('jpg')

               # 下面是準備二值化，發現總體速度還不如直接傳給百度
               # paste_image = PImage.open(StringIO.StringIO(img.make_blob('jpg')))
               # paste_image = paste_image.convert("L")
               # paste_image.show()
               # d = StringIO.StringIO()
               # paste_image.save(d, 'JPEG')
               # result = d.getvalue()

           # PDF裡面有一張以上圖片
           else:
               # 多張時，獲取最終寬高、拼接頁數
               target_width, target_height, page_num = _get_more_info(
                   target_width, img.width, img.height, image_page_num
               )

               # 生成貼上的背景圖 (測試多次，發現L比RGB快)
               paste_image = PImage.new('L', (target_width, target_height))

               # 拼接圖片
               for i in range(0, page_num):
                   image = Image(image=img.sequence[i])
                   # 計算一張圖的高度
                   one_img_height = int(target_height / page_num)
                   # 縮放
                   image.sample(target_width, one_img_height)
                   # 將wand庫檔案轉成PIL庫檔案
                   pasted_image = PImage.open(StringIO.StringIO(image.make_blob('jpg')))
                   # 將圖片貼上到背景圖
                   paste_image.paste(pasted_image, (0, one_img_height * i))

               # 如果最終高度大於百度最大高度，則crop
               if target_height > bai_du_ocr_max:
                   paste_image = paste_image.crop((0, 0, target_width, bai_du_ocr_max))

               # 從記憶體中讀取檔案
               d = StringIO.StringIO()
               # 這裡是JPEG不是JPG
               paste_image.save(d, 'JPEG')
               result = d.getvalue()
               # paste_image.save('%s.jpg' % (str(int(time.time())) + '_' + str(img.width)))
               # 測試的時候可以開啟
               # paste_image.show()
   except Exception as e:
       result = False
   return result


# 一張時獲取寬高,如果圖片寬頻大於我們想要的寬度，則等比縮放圖片高度
def _get_one_info(target_width, img_width, img_height):
   if img_width > target_width:
       ratio = target_width / img_width
       target_height = int(ratio * img_height)
   else:
       target_width = img_width
       target_height = img_height
   return target_width, target_height


# 多張時獲取寬高和拼接頁數
def _get_more_info(target_width, img_width, img_height, image_page_num):
   one_width, one_height = _get_one_info(target_width, img_width, img_height)
   if one_height < bai_du_ocr_max:
       # 百度最大高度除以每張圖高度，向上取整，即拼接圖片的數量
       num = int(math.ceil(bai_du_ocr_max / one_height))
       # 取拼接數和總頁數的最小值
       page_num = min(num, image_page_num)
       return one_width, one_height * page_num, page_num
   else:
       return one_width, one_height, 1  # 1頁


# 除錯時候用
def _ocr(content):
   url = '百度OCR連結(自己去百度OCR官網申請就行)'
   img = base64.b64encode(content)
   params = {"image": img}
   params = urllib.urlencode(params)

   request = urllib2.Request(url, params)
   request.add_header('Content-Type', 'application/x-www-form-urlencoded')
   response = urllib2.urlopen(request)
   content = response.read()
   # print content
   dict_content = json.loads(content)
   text = "\n".join(map(lambda x: x["words"], dict_content["words_result"]))
   return text


# 除錯時候用
def _write_file(path, data, type="w"):
   try:
       f = open(path, '%sb' % type)
   except:
       f = open(path.encode("utf-8"), '%sb' % type)
   f.write(data)
   f.close()


# 除錯時候用
if __name__ == '__main__':
   import sys
   import base64
   import json
   import urllib
   import urllib2
   import time

   start = time.time()
   source_file = sys.argv[1]
   ret = convert(source_file, 1500)
   end = time.time()
   # 這裡我統一儲存下檔案，方便開啟觀察
   _write_file(str(end) + '.jpg', ret)
   if ret:
       text = _ocr(ret)
   end_parse = time.time()
   print '____________________________________________'
   print end - start
   print end_parse - end
   print '+++++++++++++++++++++++++++++++++++++++++++++'
   print text
