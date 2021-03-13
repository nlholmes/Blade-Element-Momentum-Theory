function DATA = bemt(input_file)

DATA = read_inputs(input_file);
DATA = do_geom(DATA);
DATA = do_bemt(DATA);
DATA = calc_power(DATA);

return
