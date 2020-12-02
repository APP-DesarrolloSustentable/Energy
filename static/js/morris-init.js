


var day_data = [
    {"elapsed": "I", "value": 8},
    {"elapsed": "II", "value": 34},
    {"elapsed": "III", "value": 53},
    {"elapsed": "IV", "value": 12},
    {"elapsed": "V", "value": 13},
    {"elapsed": "VI", "value": 22},
    {"elapsed": "VII", "value": 5},
    {"elapsed": "VIII", "value": 26},
    {"elapsed": "IX", "value": 12},
    {"elapsed": "X", "value": 19}
];


var lineChart = new Morris.Line({
    element: 'line-chart',
    data: day_data,
    xkey: 'elapsed',
    ykeys: ['value'],
    labels: ['value'],
    gridLineColor: '#e5ebf8',
    lineColors:['#FF518A'],
    parseTime: false,
    lineWidth: 1
});


jQuery(function($) {
    $(window).on('resize', function() {
     setTimeout(function(){
     
       var $line_Chart =  $('#line-chart');
       var line_svg = $line_Chart.width();
       $line_Chart.find("svg").width(line_svg);
       lineChart.redraw();

    

    })
    });
});
