<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        .breaking-news
        {
            background: #FFF;
            border-radius: 1px;
            -moz-border-radius: 1px;
            -webkit-border-radius: 1px;
            box-shadow: 0 1px 3px 0 #B5B5B5;
            -moz-box-shadow: 0 1px 3px 0 #b5b5b5;
            -webkit-box-shadow: 0 1px 3px 0 #B5B5B5;
            width: 1045px;
            height: 32px;
            margin: 0px auto;
            overflow: hidden;
            position: relative;
        }
        .breaking-news span
        {
            display: block;
            float: left;
            padding: 0px;
            color: #FFF;
            font-family: 'Open Sans' ,arial,Georgia, serif;
            font-size: 14pt;
        }
        .breaking-news ul
        {
            float: left;
            margin: 0px;
            padding: 0px;
        }
        .breaking-news ul li
        {
            display: block;
        }
        .breaking-news ul a
        {
            padding: 8px;
            display: block;
            white-space: nowrap;
text-decoration:none;
color:#000;
        }
        .breaking-news ul a:hover
        {
          
color:#04a;
        }
        
    </style>
    <script type="text/javascript" src="jquery-2.0.3.min.js"></script>
    <script>
        function createTicker() {
            var tickerLIs = jQuery(".breaking-news ul").children();
            tickerItems = new Array();
            tickerLIs.each(function (el) {
                tickerItems.push(jQuery(this).html());
            });
            i = 0;
            rotateTicker();
        }
        function rotateTicker() {
            if (i == tickerItems.length) {
                i = 0;
            }
            tickerText = tickerItems[i];
            c = 0;
            typetext();
            setTimeout("rotateTicker()", 5000);
            i++;
        }
        var isInTag = false;
        function typetext() {
            if (jQuery('.breaking-news ul').length > 0) {
                var thisChar = tickerText.substr(c, 1);
                if (thisChar == '<') { isInTag = true; }
                if (thisChar == '>') { isInTag = false; }
                jQuery('.breaking-news ul').html(tickerText.substr(0, c++));
                if (c < tickerText.length + 1)
                    if (isInTag) {
                        typetext();
                    } else {
                        setTimeout("typetext()", 10);
                    }
                else {
                    c = 1;
                    tickerText = "";
                }
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="breaking-news">
        <span><a href="https://www.twitter.com/daltinkurt" target="_blank">
            <img src="/images/twitter.png" alt="Twitter" /></a></span>
        <ul id="ultwits" style="display: none;">
        </ul>
        <script type="text/javascript">
            jQuery(document).ready(function () {
                $("#ultwits").empty();
                $.ajax({
                    url: "TwitterHandler.ashx",
                    type: "GET",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: "{}",
                    success: function (data) {
                        $.each(data, function (x, y) {
                            $("#ultwits").append('<li><a href="' + y.url + '" target="_blank">' + y.text + '</a></li>');
                        });
                        $("#ultwits").show();
                        createTicker();
                    }
                });
 
 
            });
        </script>
    </div>
    </form>
</body>
</html>
