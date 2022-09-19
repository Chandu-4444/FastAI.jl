function load_batchseq(data, task; context = Training(), batch_size = 4, shuffle = true)
    # Create a task dataset from the data
    data = shuffle ? shuffleobs(data) : data
    td = taskdataset(data, task, context)
    x_inp = map(i -> td[i][1], 1:length(td))
    y_out = mapreduce(i -> td[i][2], hcat, 1:length(td))

    bv_x = BatchView(x_inp, batchsize = batch_size)
    bv_y = BatchView(y_out, batchsize = batch_size)

    return map((xs, ys) -> (batchseq(xs, 2), ys), bv_x, bv_y)
end

function load_genseq(data, task; context = Training(), batch_size = 4, shuffle = true)
    # Create a task dataset from the data
    data = shuffle ? shuffleobs(data) : data
    td = taskdataset(data, task, context)
    x_inp = map(i -> td[i][1][1:(end - 1)], 1:length(td))
    y_out = map(i -> td[i][2][2:end], 1:length(td))

    bv_x = BatchView(x_inp, batchsize = 4)
    # bv_y = BatchView(y_out, batchsize = batch_size)
    bv_y = BatchView(y_out, batchsize = 4)

    return map((xs, ys) -> (batchseq(xs, 2), batchseq(ys, 2)), bv_x, bv_y)
end
