module sklansky_block #(
  parameter WIDTH = 2
) (
  input  logic [WIDTH-1:0] g_in, p_in,
  output logic [WIDTH-1:0] g, p
);

  genvar i;
  generate
    if (WIDTH > 2) begin : recurse_add_layer
      // New layer, new layer-specific interconect network
      logic [WIDTH-1:0] g_l, p_l;

      // Generate parent layers
      sklansky_block #(WIDTH/2) upper_parent (
        .g_in(g_in[WIDTH-1:WIDTH/2]),
        .p_in(p_in[WIDTH-1:WIDTH/2]),
        .g(g_l[WIDTH-1:WIDTH/2]),
        .p(p_l[WIDTH-1:WIDTH/2])
      );
      sklansky_block #(WIDTH/2) lower_parent (
        .g_in(g_in[WIDTH/2-1:0]),
        .p_in(p_in[WIDTH/2-1:0]),
        .g(g_l[WIDTH/2-1:0]),
        .p(p_l[WIDTH/2-1:0])
      );

      // Generate this layer's blackcells
      // - upper half get blackcells with RHS connected to top bit of lower half
      for (i=WIDTH/2; i<WIDTH; i+=1) begin
        blackcell upper_node (
          .g_in({g_l[i], g_l[WIDTH/2-1]}),
          .p_in({p_l[i], p_l[WIDTH/2-1]}),
          .g(g[i]),
          .p(p[i])
        );
      end
      // - lower half get assigns/buffers
      for (i=0; i<WIDTH/2; i+=1) begin
        assign g[i] = g_l[i];
        assign p[i] = p_l[i];
      end
    end else begin : base_layer
      // Use the basic sklansky block
      blackcell node (
        .g_in(g_in[1:0]),
        .p_in(p_in[1:0]),
        .g(g[1]),
        .p(p[1])
      );

      // TODO: should these be replaced with buffers? i.e. buf({g_in[0], p_in[0]}, {g[0], p[0]})
      assign g[0] = g_in[0];
      assign p[0] = p_in[0];
    end
  endgenerate

endmodule
