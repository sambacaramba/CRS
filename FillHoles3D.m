function  [Data holes_filled] = FillHoles3D(input, fillvol)
% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)

%input a 3D binary volume 
%fillvol the size of the holes to fill (500 fills all holes less than 500 voxels)

 [x, y, z] =  size(input)
   input = logical(input);
   %sweep volume
   input_inverse = ~input;
  holes = false(x,y,z);
 object = bwconncomp(input_inverse)
 'Calculating holes from inversed volume'
 numPixels = cellfun(@numel,object.PixelIdxList);
 holes_filled = 0
 for i = 1:length(numPixels)
 
     holesize = numPixels(1,i);
     
     if holesize < fillvol
     
    holes(object.PixelIdxList{i}) = 1;
    holes_filled = holes_filled+1;
     else 
     end
 end
 holes_filled
 input(holes) = 1;
 Data = input;
  