
module array_unpacked_2d #(
  // parameters for array sizes
  parameter WA = 8,  // address dimension size (row)
  parameter WC = 8,  // address dimension size (column)
  parameter WB = 8   // bit     dimension size
)();

// 2D unpacked arrays (test and reference)
logic [WB-1:0] array_bg [WA-1:0] [WC-1:0], rfrnc_bg [WA-1:0] [WC-1:0];  // big endian array
logic [0:WB-1] array_lt [0:WA-1] [0:WC-1], rfrnc_lt [0:WA-1] [0:WC-1];  // little endian array


initial begin
  test_array_readmemb(WA, WC, WB);
end

task test_array_readmemb (
  input integer wa, wc, wb
);
  integer a, c, b;
  integer txt_file;
  logic [64*8-1:0] filename;
begin
  // create reference file
  $swrite (filename, "array_unpacked_%03d_x_%03d_x_%03d.txt", wa, wc, wb);
  txt_file = $fopen(filename, "w");
  for (a=0; a<wa; a=a+1) begin
    for (c=0; b<wc; c=c+1) begin
      $fwrite(txt_file, "%x ", {a[WB/2-1:0], c[WB/2-1:0]});
    end
    $fwrite(txt_file, "\n");
  end
  $fclose(txt_file);
  
  // big endian
  $display("test readmemb (%03d x %03d x %03d) into array (%03d x %03d x %03d) big    endian", wa, wc, wb, WA, WC, WB);
  // clear and polulate reference array
  for (a=0; a<WA; a=a+1)  for (c=0; c<WC; c=c+1)  array_bg [a][c] = {WB{1'bx}};
  for (a=0; a<WA; a=a+1)  for (c=0; c<WC; c=c+1)  rfrnc_bg [a][c] = {WB{1'bx}};
  for (a=0; a<wa; a=a+1)  for (c=0; c<wc; c=c+1)  rfrnc_bg [a][c] = {a[WB/2-1:0], c[WB/2-1:0]};
  // access file
  $readmemh  ({filename       }, array_bg);
  $writememh ({filename, ".bg"}, array_bg);
  // compare array against reference
  if (array_bg === rfrnc_bg)  $display ("PASSED");
  else                        $display ("FAILED");

  // big endian
  $display("test readmemb (%03d x %03d x %03d) into array (%03d x %03d x %03d) little endian", wa, wc, wb, WA, WC, WB);
  // clear and polulate reference array
  for (a=0; a<WA; a=a+1)  for (c=0; c<WC; c=c+1)  array_lt [a][c] = {WB{1'bx}};
  for (a=0; a<WA; a=a+1)  for (c=0; c<WC; c=c+1)  rfrnc_lt [a][c] = {WB{1'bx}};
  for (a=0; a<wa; a=a+1)  for (c=0; c<wc; c=c+1)  rfrnc_lt [a][c] = {a[WB/2-1:0], c[WB/2-1:0]};
  // access file
  $readmemh  ({filename       }, array_lt);
  $writememh ({filename, ".lt"}, array_lt);
  // compare array against reference
  if (array_lt === rfrnc_lt)  $display ("PASSED");
  else                        $display ("FAILED");
end
endtask

endmodule
