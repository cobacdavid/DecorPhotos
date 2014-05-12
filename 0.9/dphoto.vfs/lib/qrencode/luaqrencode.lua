qrencode = dofile('/tmp/qrencode.lua')
local ok, t  = qrencode.qrcode(arg[1])

if not ok then
    print(t)
end

bordW = 1
bord={}
for i=1,#t+2*bordW do
   bord[i]={}
   for j=1,#t+2*bordW do
      bord[i][j]=0
   end
end


for j=1,#t do
   for i=1,#t do
      if t[i][j] < 0 then
	 bord[j+bordW][i+bordW] = 0
      else
	 bord[j+bordW][i+bordW] = 1
      end
   end
end

coeff = 10
scale={}
for i=1,coeff*#bord do
   u= ""
   scale[i]={}
   for j=1,coeff*#bord do
      scale[i][j] = bord[math.ceil(i/coeff)][math.ceil(j/coeff)]
      u = u .. scale[i][j]
   end
   print(u)
end
