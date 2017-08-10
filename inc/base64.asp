<%
     'OPTION EXPLICIT
     const BASE_64_MAP_INIT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
     dim nl
     '' zero based arrays
     dim Base64EncMap(63)
     dim Base64DecMap(127)

     '' must be called before using anything else
     PUBLIC SUB initCodecs()
          '' init vars
          nl = "<P>" & chr(13) & chr(10)
          '' setup base 64
          dim max, idx
             max = len(BASE_64_MAP_INIT)
          for idx = 0 to max - 1
               '' one based string
               Base64EncMap(idx) = mid(BASE_64_MAP_INIT, idx + 1, 1)
          next
          for idx = 0 to max - 1
               Base64DecMap(ASC(Base64EncMap(idx))) = idx
          next
     END SUB

     '' encode base 64 encoded string
     PUBLIC FUNCTION base64Encode(plain)

          if len(plain) = 0 then
               base64Encode = ""
               exit function
          end if

          dim ret, ndx, by3, first, second, third
          by3 = (len(plain) \ 3) * 3
          ndx = 1
          do while ndx <= by3
               first  = asc(mid(plain, ndx+0, 1))
               second = asc(mid(plain, ndx+1, 1))
               third  = asc(mid(plain, ndx+2, 1))
               ret = ret & Base64EncMap(  (first \ 4) AND 63 )
               ret = ret & Base64EncMap( ((first * 16) AND 48) + ((second \ 16) AND 15 ) )
               ret = ret & Base64EncMap( ((second * 4) AND 60) + ((third \ 64) AND 3 ) )
               ret = ret & Base64EncMap( third AND 63)
               ndx = ndx + 3
          loop
          '' check for stragglers
          if by3 < len(plain) then
               first  = asc(mid(plain, ndx+0, 1))
               ret = ret & Base64EncMap(  (first \ 4) AND 63 )
               if (len(plain) MOD 3 ) = 2 then
                    second = asc(mid(plain, ndx+1, 1))
                    ret = ret & Base64EncMap( ((first * 16) AND 48) + ((second \ 16) AND 15 ) )
                    ret = ret & Base64EncMap( ((second * 4) AND 60) )
               else
                    ret = ret & Base64EncMap( (first * 16) AND 48)
                    ret = ret & "="
               end if
               ret = ret & "="
          end if

          base64Encode = ret
     END FUNCTION

     '' decode base 64 encoded string
     PUBLIC FUNCTION base64Decode(scrambled)

          if len(scrambled) = 0 then
               base64Decode = ""
               exit function
          end if

          '' ignore padding
          dim realLen
          realLen = len(scrambled)
          do while mid(scrambled, realLen, 1) = "="
               realLen = realLen - 1
          loop
          dim ret, ndx, by4, first, second, third, fourth
          ret = ""
          by4 = (realLen \ 4) * 4
          ndx = 1
          do while ndx <= by4
               first  = Base64DecMap(asc(mid(scrambled, ndx+0, 1)))
               second = Base64DecMap(asc(mid(scrambled, ndx+1, 1)))
               third  = Base64DecMap(asc(mid(scrambled, ndx+2, 1)))
               fourth = Base64DecMap(asc(mid(scrambled, ndx+3, 1)))
               ret = ret & chr( ((first * 4) AND 255) +   ((second \ 16) AND 3) )
               ret = ret & chr( ((second * 16) AND 255) + ((third \ 4) And 15) )
               ret = ret & chr( ((third * 64) AND 255) +  (fourth AND 63) )
               ndx = ndx + 4
          loop
          '' check for stragglers, will be 2 or 3 characters
          if ndx < realLen then
               first  = Base64DecMap(asc(mid(scrambled, ndx+0, 1)))
               second = Base64DecMap(asc(mid(scrambled, ndx+1, 1)))
               ret = ret & chr( ((first * 4) AND 255) +   ((second \ 16) AND 3) )
               if realLen MOD 4 = 3 then
                    third = Base64DecMap(asc(mid(scrambled,ndx+2,1)))
                    ret = ret & chr( ((second * 16) AND 255) + ((third \ 4) And 15) )
               end if
          end if

          base64Decode = ret
     END FUNCTION

'' initialize


Function auth_code(str, action, key)
  call initCodecs
  If str = "" Then 
	auth_code = ""
	Exit Function
  End If
  key = md5(key,32)
  key_length = Len(key)
  skip = (Asc(Mid(key,1,1)) + Asc(Mid(key,key_length,1))) mod key_length
  If action = "decode" Then
    str = base64Decode(str)
  Else
    str = Mid(md5(key,32),1,8) & str
  End If
  str_length = Len(str)
  ReDim box(0)
  For i = 1 To key_length
    ReDim Preserve box(i)
    box(i-1) = (Asc(Mid(key,i,1)) + skip) mod 128
  Next
  result = ""
  For i = 1 To str_length
  'response.write chr(Asc( Mid(str,i,1)) Xor box((i -1) * skip Mod key_length))
  'response.write "<br>"
    result = result & chr(Asc( Mid(str,i,1)) Xor box((i -1) * skip Mod key_length))
  Next
  'response.end
  If action = "decode" Then
	If Mid(result,1,8) = Mid(md5(key,32), 1, 8) Then
	  auth_code = Mid(result,8)
	Else
	  auth_code = result
	End If
  Else
    auth_code = Replace(base64Encode(result), "=", "")
  End If
End Function


'response.write md5("G8K7biHD")
'response.end

'response.write server.urlencode(auth_code("email=test2@li.com&pwd=G8K7biHD&domain=http://192.168.0.37:8080/", "encode", "9D78DC9E"))




'response.write auth_code("YzV6NnosMC4rEmE7PW18M2ANMRIkMSgwLxwgJmghOho8Mn1qD35jDAg9OGUUYnpBFWs3EiI1Ij08Fzs/PmtiUTAyfH17YGRjf0U4YmlgYHg+IQwOKiY9NnNRLjg+", "decode", "44590B72")

'response.end

%>

