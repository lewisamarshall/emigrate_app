exporter = this

margin = {top: 200, right: 50, bottom: 200, left: 50}
width = 960 - margin.left - margin.right
height = 500 - margin.bottom - margin.top

x = d3.scale.linear()
      .domain([0, 180])
      .range([0, width])
      .clamp(true)

brush = d3.svg.brush()
          .x(x)
          .extent([0, 0])
          .on("brush", brushed)

svg = d3.select("body").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height / 2 + ")")
    .call(d3.svg.axis()
      .scale(x)
      .orient("bottom")
      .tickFormat((d)->return d + "°" )
      .tickSize(0)
      .tickPadding(12))
  .select(".domain")
  .select(()->return this.parentNode.appendChild(this.cloneNode(true)))
    .attr("class", "halo")

slider = svg.append("g")
    .attr("class", "slider")
    .call(brush)

slider.selectAll(".extent,.resize")
    .remove()

slider.select(".background")
    .attr("height", height)

slider
    .call(brush.event)
  .transition()
    .duration(750)
    .call(brush.extent([70, 70]))
    .call(brush.event)

handle = slider.append("circle")
    .attr("class", "handle")
    .attr("transform", "translate(0," + height / 2 + ")")
    .attr("r", 9)


brushed=()->
  value = brush.extent()[0]

  if (d3.event.sourceEvent)
    value = x.invert(d3.mouse(this)[0])
    brush.extent([value, value])
  handle.attr("cx", x(value))
  console.log(value)
