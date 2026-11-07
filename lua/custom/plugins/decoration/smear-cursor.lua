return {
  'sphamba/smear-cursor.nvim',
  opts = {
    -- How fast the smear's head moves towards the target.
    -- 0: no movement, 1: instantaneous
    stiffness = 0.8,
    stiffness_insert_mode = 0.7,
    -- How fast the smear's tail moves towards the target.
    -- 0: no movement, 1: instantaneous
    trailing_stiffness = 0.6,
    -- Initial velocity factor in the direction opposite to the target
    anticipation = 0.2,
    -- Velocity reduction over time. O: no reduction, 1: full reduction
    damping = 0.95,
    damping_insert_mode = 0.95,
    -- Stop animating when the smear's tail is within this distance (in characters) from the target.
    distance_stop_animating = 0.5,

    time_interval = 7,
  },
}
