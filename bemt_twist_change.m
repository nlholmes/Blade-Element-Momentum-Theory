function DATA = bemt_twist_change(input_file, newTipTwist)

DATA = read_inputs(input_file);
DATA.tip_twist = newTipTwist; % changes the tip twist value before it is used in do_geom
DATA = do_geom(DATA);
DATA = do_bemt(DATA);
DATA = calc_power(DATA);

return
