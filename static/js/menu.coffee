root = global ? window

Queue = (list) ->
  queue = new CircularQueue(list.length)
  for item in list
    queue.push item
  queue

examples =
  javascript: Queue(["""
      var members = [45, 10, 3, 22, 7];
      $('p.allmem').html(members.join("<br>"));
      members = members.sort(function (a, b) {
          return a - b;
      });
      $('p.sorted').html(members.join("<br>"));
    """, """
      $('.message').hide();
      $('span.readmore').toggle(function () {
          $('.message').show('slow');
          $(this).text("Read Less…");
      }, function () {
          $('.message').hide('slow');
          $(this).text("Read More…");
      });
    """, """
      $('.buttons').bind('click', function () {
          alert('You have clicked the ' + $(this).text() + ' button');
      });
      $('.italic').trigger('click');
    """])
  opal: Queue(["""
      # Code from from http://dev.mikamai.com/post/87806500959/learning-d3-js-basics-with-ruby-and-opal
      d3 = Native(`window.d3`)
      time  = d3[:time]
      scale = d3[:scale]
      svg   = d3[:svg]

      date_parser = time.format("%d-%b-%y")

      x = time.scale.range([0, width])
      y = scale.linear.range([height, 0])

      x_axis = svg.axis.scale(x).orient(:bottom)
      y_axis = svg.axis.scale(y).orient(:left)
    """, """
      class User
        attr_accessor :name

        def initialize(name)
          @name = name
        end

        def admin?
          @name == 'Admin'
        end
      end

      user = User.new('Bob')
      puts user
      puts user.admin?
    """, """
      # Code from http://sandbox.mc.edu/~bennet/ruby/code/poly_rb.html
      #
      # This program evaluates polynomials.  It first asks for the coefficients
      # of a polynomial, which must be entered on one line, highest-order first.
      # It then requests values of x and will compute the value of the poly for
      # each x.  It will repeatly ask for x values, unless you the user enters
      # a blank line.  It that case, it will ask for another polynomial.  If the
      # user types quit for either input, the program immediately exits.
      #

      #
      # Function to evaluate a polynomial at x.  The polynomial is given
      # as a list of coefficients, from the greatest to the least.
      def polyval(x, coef)
          sum = 0
          coef = coef.clone           # Don't want to destroy the original
          while true
              sum += coef.shift       # Add and remove the next coef
              break if coef.empty?    # If no more, done entirely.
              sum *= x                # This happens the right number of times.
          end
          return sum
      end

      #
      # Function to read a line containing a list of integers and return
      # them as an array of integers.  If the string conversion fails, it
      # throws TypeError.  If the input line is the word 'quit', then it
      # converts it to an end-of-file exception
      def readints(prompt)
          # Read a line
          print prompt
          line = readline.chomp
          raise EOFError.new if line == 'quit' # You can also use a real EOF.

          # Go through each item on the line, converting each one and adding it
          # to retval.
          retval = [ ]
          for str in line.split(/\s+/)
              if str =~ /^\-?\d+$/
                  retval.push(str.to_i)
              else
                  raise TypeError.new
              end
          end

          return retval
      end

      #
      # Take a coeff and an exponent and return the string representation, ignoring
      # the sign of the coefficient.
      def term_to_str(coef, exp)
          ret = ""

          # Show coeff, unless it's 1 or at the right
          coef = coef.abs
          ret = coef.to_s     unless coef == 1 && exp > 0
          ret += "x" if exp > 0                               # x if exponent not 0
          ret += "^" + exp.to_s if exp > 1                    # ^exponent, if > 1.

          return ret
      end

      #
      # Create a string of the polynomial in sort-of-readable form.
      def polystr(p)
          # Get the exponent of first coefficient, plus 1.
          exp = p.length

          # Assign exponents to each term, making pairs of coeff and exponent,
          # Then get rid of the zero terms.
          p = (p.map { |c| exp -= 1; [ c, exp ] }).select { |p| p[0] != 0 }

          # If there's nothing left, it's a zero
          return "0" if p.empty?

          # *** Now p is a non-empty list of [ coef, exponent ] pairs. ***

          # Convert the first term, preceded by a "-" if it's negative.
          result = (if p[0][0] < 0 then "-" else "" end) + term_to_str(*p[0])

          # Convert the rest of the terms, in each case adding the appropriate
          # + or - separating them.
          for term in p[1...p.length]
              # Add the separator then the rep. of the term.
              result += (if term[0] < 0 then " - " else " + " end) +
                      term_to_str(*term)
          end

          return result
      end

      #
      # Run until some kind of endfile.
      begin
          # Repeat until an exception or quit gets us out.
          while true
              # Read a poly until it works.  An EOF will except out of the
              # program.
              print "\n"
              begin
                  poly = readints("Enter a polynomial coefficients: ")
              rescue TypeError
                  print "Try again.\n"
                  retry
              end
              break if poly.empty?

              # Read and evaluate x values until the user types a blank line.
              # Again, an EOF will except out of the pgm.
              while true
                  # Request an integer.
                  print "Enter x value or blank line: "
                  x = readline.chomp
                  break if x == ''
                  raise EOFError.new if x == 'quit'

                  # If it looks bad, let's try again.
                  if x !~ /^\-?\d+$/
                      print "That doesn't look like an integer.  Please try again.\n"
                      next
                  end

                  # Convert to an integer and print the result.
                  x = x.to_i
                  print "p(x) = ", polystr(poly), "\n"
                  print "p(", x, ") = ", polyval(x, poly), "\n"
              end
          end
      rescue EOFError
          print "\n=== EOF ===\n"
      rescue Interrupt, SignalException
          print "\n=== Interrupted ===\n"
      else
          print "--- Bye ---\n"
      end

    """
  ])
  coffeescript: Queue(["""
      $.post(
        "/posts/update_title"
        new_title: input.val()
        id: something
        -> alert('done')
        'json'
      )
    """, """
      $('#logo')
        .css(fontSize:  64)
        .hover(->  $(this).css(fontWeight:  'bold'))
        .click(->  alert  'How  dare  you  click  the  mighty  logo!')
    """, """
      _.map = (obj, iterator, context) ->
        return obj.map(iterator, context) if nativeMap and obj.map is nativeMap
        results = []
        _.each obj, (value, index, list) ->
          results.push iterator.call context, value, index, list
        results
      _.reduce = (obj, iterator, memo, context) ->
        if nativeReduce and obj.reduce is nativeReduce
          iterator = _.bind iterator, context if context
          return obj.reduce iterator, memo
        _.each obj, (value, index, list) ->
          memo = iterator.call context, memo, value, index, list
        memo
    """, atob('Y2xhc3MgQW5pbWFsDQogIGNvbnN0cnVjdG9yOiAoQG5hbWUpIC0+DQoNCiAgbW92ZTogKG1ldGVycykgLT4NCiAgICBhbGVydCBAbmFtZSArICIgbW92ZWQgI3ttZXRlcnN9bS4iDQoNCmNsYXNzIFNuYWtlIGV4dGVuZHMgQW5pbWFsDQogIG1vdmU6IC0+DQogICAgYWxlcnQgIlNsaXRoZXJpbmcuLi4iDQogICAgc3VwZXIgNQ0KDQpjbGFzcyBIb3JzZSBleHRlbmRzIEFuaW1hbA0KICBtb3ZlOiAtPg0KICAgIGFsZXJ0ICJHYWxsb3BpbmcuLi4iDQogICAgc3VwZXIgNDUNCg0Kc2FtID0gbmV3IFNuYWtlICJTYW1teSB0aGUgUHl0aG9uIg0KdG9tID0gbmV3IEhvcnNlICJUb21teSB0aGUgUGFsb21pbm8iDQoNCnNhbS5tb3ZlKCkNCnRvbS5tb3ZlKCk=')
  ])
  typescript: Queue(["""
      function area(shape: string, width: number, height: number) {
         var area = width * height;
         return "I'm a " + shape + " with an area of " + area + " cm squared.";
      }

      document.body.innerHTML = area("rectangle", 30, 15);
    """, """
      interface Shape {
         name: string;
         width: number;
         height: number;
         color?: string;
      }

      function area(shape : Shape) {
         var area = shape.width * shape.height;
         return "I'm " + shape.name + " with area " + area + " cm squared";
      }

      console.log( area( {name: "rectangle", width: 30, height: 15} ) );
      console.log( area( {name: "square", width: 30, height: 30, color: "blue"} ) );
    """, """
      var shape = {
         name: "rectangle",
         popup: function() {

            console.log('This inside popup(): ' + this.name);

            setTimeout(function() {
               console.log('This inside setTimeout(): ' + this.name);
               console.log("I'm a " + this.name + "!");
            }, 3000);

         }
      };

      shape.popup();
    """, """
      class Shape {

         area: number;
         color: string;

         constructor ( name: string, width: number, height: number ) {
            this.area = width * height;
            this.color = "pink";
         };

         shoutout() {
            return "I'm " + this.color + " " + this.name +  " with an area of " + this.area + " cm squared.";
         }
      }

      var square = new Shape("square", 30, 30);

      console.log( square.shoutout() );
      console.log( 'Area of Shape: ' + square.area );
      console.log( 'Name of Shape: ' + square.name );
      console.log( 'Color of Shape: ' + square.color );
      console.log( 'Width of Shape: ' + square.width );
      console.log( 'Height of Shape: ' + square.height );
    """
  ])
  sass: Queue(["""
      @import "compass/layout/stretching";
      @import "compass/utilities";
      @import "compass/css3";

      .stretch-container {
        border: 1px solid #999999;
        width: 200px;
        height: 200px;
        position: relative;
        @include inline-block; }

      .stretched {
        $stretch-color: #4c6b99;
        border: 3px solid $stretch-color;
        @include border-radius(8px);
        display: block;
        background-color: darken($stretch-color, 30%);
        color: white;
        text-align: center;
        vertical-align: middle;
        padding: 0.5em; }

      #stretch-full {
        @extend .stretched;
        @include stretch; }

      #stretch-offset {
        @extend .stretched;
        @include stretch(1em, 1em, 1em, 1em); }

      #stretch-x {
        @extend .stretched;
        @include stretch-x; }

      #stretch-y {
        @extend .stretched;
        @include stretch-y; }
    """, """
      @import compass
      .ex
        width: 48%
        margin-right: 2%
        float: left
        +clearfix

      .gradient-example
        width: 80px
        height: 80px
        background: red
        float: left
        margin: 1em 1em 0 0

      // This will yield a radial gradient with an apparent specular highlight
      #radial-gradient
        +background-image(radial-gradient(45px 45px, #0ff 10px, #1e90ff 30px))

      // This yields a linear gradient spanning from the upper left corner to the lower right corner
      #linear-gradient
        +background-image(linear-gradient(left top, #fff, #ddd))

      // This yields a gradient starting at the top with #fff, ending in #aaa
      #v-gradient
        +background-image(linear-gradient(#fff, #aaa))

      // Same as above but with a #ccc at the halfway point
      #v-gradient-2
        +background-image(linear-gradient(#fff, #ccc, #aaa))

      // Same as the first example but with #ccc at the 30% from the top, and #bbb at 70% from the top
      #v-gradient-3
        +background-image(linear-gradient(#fff, #ccc 30%, #bbb 70%, #aaa))

      // This yields a horizontal linear gradient spanning from left to right.
      #h-gradient
        +background-image(linear-gradient(left, #fff, #ddd))

      #svg-gradient
        $experimental-support-for-svg: true
        +background-image(linear-gradient(left, #2ac363, #cd8c14, #9c4cc2))
        width: 80px
        height: 80px
    """, """
      @import "compass/utilities/tables"
      table
        $table-color : #7a98c6
        +table-scaffolding
        +inner-table-borders(1px, darken($table-color, 40%))
        +outer-table-borders(2px)
        +alternating-rows-and-columns($table-color, adjust-hue($table-color, -120deg), #222)
    """
  ])
  scss: Queue(["""
      @import "compass/layout/stretching"
      @import "compass/utilities"
      @import "compass/css3"

      .stretch-container
        border: 1px solid #999
        width: 200px
        height: 200px
        position: relative
        +inline-block
      .stretched
        $stretch-color: #4C6B99
        border: 3px solid $stretch-color
        +border-radius(8px)
        display: block
        background-color: darken($stretch-color, 30%)
        color: white
        text-align: center
        vertical-align: middle
        padding: 0.5em
      #stretch-full
        @extend .stretched
        +stretch
      #stretch-offset
        @extend .stretched
        +stretch(1em, 1em, 1em, 1em)
      #stretch-x
        @extend .stretched
        +stretch-x
      #stretch-y
        @extend .stretched
        +stretch-y
    """, """
      @import "compass";

      .ex {
        width: 48%;
        margin-right: 2%;
        float: left;
        @include clearfix; }

      .gradient-example {
        width: 80px;
        height: 80px;
        background: red;
        float: left;
        margin: 1em 1em 0 0; }

      // This will yield a radial gradient with an apparent specular highlight
      #radial-gradient {
        @include background-image(radial-gradient(45px 45px, aqua 10px, #1e90ff 30px)); }

      // This yields a linear gradient spanning from the upper left corner to the lower right corner
      #linear-gradient {
        @include background-image(linear-gradient(left top, white, #dddddd)); }

      // This yields a gradient starting at the top with #fff, ending in #aaa
      #v-gradient {
        @include background-image(linear-gradient(white, #aaaaaa)); }

      // Same as above but with a #ccc at the halfway point
      #v-gradient-2 {
        @include background-image(linear-gradient(white, #cccccc, #aaaaaa)); }

      // Same as the first example but with #ccc at the 30% from the top, and #bbb at 70% from the top
      #v-gradient-3 {
        @include background-image(linear-gradient(white, #cccccc 30%, #bbbbbb 70%, #aaaaaa)); }

      // This yields a horizontal linear gradient spanning from left to right.
      #h-gradient {
        @include background-image(linear-gradient(left, white, #dddddd)); }

      #svg-gradient {
        $experimental-support-for-svg: true;
        @include background-image(linear-gradient(left, #2ac363, #cd8c14, #9c4cc2));
        width: 80px;
        height: 80px; }
    """, """
      @import "compass/utilities/tables";

      table {
        $table-color: #7a98c6;
        @include table-scaffolding;
        @include inner-table-borders(1px, darken($table-color, 40%));
        @include outer-table-borders(2px);
        @include alternating-rows-and-columns($table-color, adjust-hue($table-color, -120deg), #222222); }
    """
  ])
  haml: Queue(["""
      #home
        title
        %ul.menu
          %li Go Home
          %li Go Back
    """, """
      #layout
        #header
          %h1 Sticky Footer Example

        %p
          This is the main content area.
        %p
          In this example you should pretend that the red box
          is actually the browser window.
        %p
          Because, being a contrived example, it's not actually sticking
          to the bottom of the page.
        #layout_footer
      #footer
        This is the footer area.
    """, """
      %table{:cellspacing => "0"}
        %thead
          %tr.odd
            %th Title
            %th One
            %th Two
            %th Three
            %th Four
            %th Row Total
        %tbody
          %tr.even
            %th Single
            %td.numeric 1.0
            %td.numeric 2.0
            %td.numeric 3.0
            %td.numeric 4.0
            %td.numeric 10.0
          %tr.odd
            %th Tens
            %td.numeric 10.0
            %td.numeric 20.0
            %td.numeric 30.0
            %td.numeric 40.0
            %td.numeric 100.0
        %tfoot
          %tr.even
            %th Total
            %td.numeric 11.0
            %td.numeric 22.0
            %td.numeric 33.0
            %td.numeric 44.0
            %td.numeric 110.0
    """
  ])
  html: Queue(["""
      <!--tab expansion of div#page>div.logo+ul#navigation>li*5>a-->
      <div id="page">
              <div class="logo"></div>
              <ul id="navigation">
                      <li><a href=""></a></li>
                      <li><a href=""></a></li>
                      <li><a href=""></a></li>
                      <li><a href=""></a></li>
                      <li><a href=""></a></li>
              </ul>
      </div>
  """, """
      <!--tab expansion of p>{Click }+a{here}+{ to continue}-->
      <p>Click <a href="">here</a> to continue</p>
  ""","""
    <article>
    <h1>Title of Post</h1>
    <p>Content of post...</p>

    <p>Content of post...</p>

    </article>
    <section>
      <section>
      <p>Comment by: Comment Author</p>
      <p>Comment #1 goes here...</p>
      </section> <section> <p>Comment by: Comment Author</p>
      <p>Comment #2 goes here...</p>
      </section> <section> <p>Comment by: Comment Author</p>
      <p>Comment #3 goes here...</p>
      </section>
    </section>
  """, """
    <form>
     <p><label>Customer name: <input></label></p>
     <fieldset>
      <legend> Pizza Size </legend>
      <p><label> <input type=radio name=size> Small </label></p>
      <p><label> <input type=radio name=size> Medium </label></p>
      <p><label> <input type=radio name=size> Large </label></p>
     </fieldset>
     <fieldset>
      <legend> Pizza Toppings </legend>
      <p><label> <input type=checkbox> Bacon </label></p>
      <p><label> <input type=checkbox> Extra Cheese </label></p>
      <p><label> <input type=checkbox> Onion </label></p>
      <p><label> <input type=checkbox> Mushroom </label></p>
     </fieldset>
    </form>
  """])
  jade: Queue([atob('dWwjdXNlcnMNCiAgZWFjaCB1c2VyLCBuYW1lIGluIHVzZXJzDQogICAgLy8gZXhwYW5kcyB0byBpZiAodXNlci5pc0EgPT0gJ2ZlcnJldCcpDQogICAgaWYgdXNlci5pc0EgPT0gJ2ZlcnJldCcNCiAgICAgIGxpKGNsYXNzPSd1c2VyLScgKyBuYW1lKSAje25hbWV9IGlzIGp1c3QgYSBmZXJyZXQNCiAgICBlbHNlDQogICAgICBsaShjbGFzcz0ndXNlci0nICsgbmFtZSkgI3tuYW1lfSAje3VzZXIuZW1haWx9DQogICAgICAgIA0KLy8gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS1qYXZhc2NyaXB0LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KLy8gbG9jYWxzLnVzZXJzID0gew0KLy8gICB0ajogeyBhZ2U6IDIzLCBlbWFpbDogJ3RqQHZpc2lvbi1tZWRpYS5jYScsIGlzQTogJ2h1bWFuJyB9LA0KLy8gICB0b2JpOiB7IGFnZTogMSwgZW1haWw6ICd0b2JpQGlzLWFtYXppbmcuY29tJywgaXNBOiAnZmVycmV0JyB9DQovLyB9Ow=='),
    """
    form(method="post")
    fieldset
      legend General
      p
        label(for="user[name]") Username:
          input(type="text", name="user[name]", value=user.name)
      p
        label(for="user[email]") Email:
          input(type="text", name="user[email]", value=user.email)
          .tip.
            Enter a valid
            email address
            such as <em>tj@vision-media.ca</em>.
    fieldset
      legend Location
      p
        label(for="user[city]") City:
          input(type="text", name="user[city]", value=user.city)
      p
        select(name="user[province]")
          option(value="") -- Select Province --
          option(value="AB") Alberta
          option(value="BC") British Columbia
          option(value="SK") Saskatchewan
          option(value="MB") Manitoba
          option(value="ON") Ontario
          option(value="QC") Quebec
    p.buttons
      input(type="submit", value="Save")

    // --------------------------javascript----------------------------
    // locals.user = {
    //     name: 'TJ',
    //     email: 'tj@vision-media.ca',
    //     city: 'Victoria',
    //     province: 'BC'
    //   };
  """, atob('fCBBbiBleGFtcGxlIG9mIGFuDQphKGhyZWY9JyMnKSBpbmxpbmUNCnwgbGluay4NCg0KZm9ybQ0KICBsYWJlbCBVc2VybmFtZToNCiAgICBpbnB1dCh0eXBlPSd0ZXh0JywgbmFtZT0ndXNlcltuYW1lXScpDQogICAgcA0KICAgICAgfCBKdXN0IGFuIGV4YW1wbGUgb2Ygc29tZSB0ZXh0IHVzYWdlLg0KICAgICAgfCBZb3UgY2FuIGhhdmUgPGVtPmlubGluZTwvZW0+IGh0bWwsDQogICAgICB8IGFzIHdlbGwgYXMNCiAgICAgIHN0cm9uZyB0YWdzDQogICAgICB8IC4NCg0KICAgICAgfCBJbnRlcnBvbGF0aW9uIGlzIGFsc28gc3VwcG9ydGVkLiBUaGUgDQogICAgICB8IHVzZXJuYW1lIGlzIGN1cnJlbnRseSAiI3tuYW1lfSIuDQoNCiAgbGFiZWwgRW1haWw6DQogICAgaW5wdXQodHlwZT0ndGV4dCcsIG5hbWU9J3VzZXJbZW1haWxdJykNCiAgICBwDQogICAgICB8IEVtYWlsIGlzIGN1cnJlbnRseQ0KICAgICAgZW09IGVtYWlsDQogICAgICB8IC4NCg0KICAvLyBhbHRlcm5hdGl2ZWx5LCBpZiB3ZSBwbGFuIG9uIGhhdmluZyBvbmx5DQogIC8vIHRleHQgb3IgaW5saW5lLWh0bWwsIHdlIGNhbiB1c2UgYSB0cmFpbGluZw0KICAvLyAiLiIgdG8gbGV0IGphZGUga25vdyB3ZSB3YW50IHRvIG9taXQgcGlwZXMNCiAgDQogIGxhYmVsIFVzZXJuYW1lOg0KICAgIGlucHV0KHR5cGU9J3RleHQnKQ0KICAgIHAuDQogICAgICBKdXN0IGFuIGV4YW1wbGUsIGxpa2UgYmVmb3JlDQogICAgICBob3dldmVyIG5vdyB3ZSBjYW4gb21pdCB0aG9zZQ0KICAgICAgYW5ub3lpbmcgcGlwZXMhLg0KICAgICAgDQogICAgICBXYWhvby4NCg0KLy8gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS1qYXZhc2NyaXB0LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KLy8gbG9jYWxzLm5hbWUgPSAndGonOw0KLy8gbG9jYWxzLmVtYWlsID0gJ3RqQHZpc2lvbi1tZWRpYS5jYSc7')])
  coffeekup: Queue(["""
    div '.navbar.navbar-fixed-top', ->
      div '.navbar-inner', ->
        div '.container', ->
          a '.brand', href: '/', 'Creamer'
          div '.nav-collapse', ->
            ul '.nav', ->
              li @home || '', ->
                a href: '/', 'Home'
              li @about || '', ->
                a href: '/about', 'About'

    div '.container', ->
      div '.row-fluid', ->
        div '.span8', -> content()
        div '.span4', ->
          div '.hero-unit', ->
            h2 'Creamer'
            p 'A great way to add coffee to flatiron'
  """
    atob('QHRpdGxlID0gJ0xvZyBJbicNCg0KaDEgQHRpdGxlDQoNCnAgIkEgbG9jYWwgdmFyOiAje3Bpbmd9Ig0KcCAiQSBjb250ZXh0IHZhcjogI3tAZm9vfSINCg0KZm9ybSBhY3Rpb246ICcvJywgbWV0aG9kOiAncG9zdCcsIC0+DQogIGRpdiBjbGFzczogJ2ZpZWxkJywgLT4NCiAgICBsYWJlbCBmb3I6ICd1c2VybmFtZScsIC0+ICdVc2VybmFtZTogJw0KICAgIGlucHV0IGlkOiAndXNlcm5hbWUnLCBuYW1lOiAndXNlcm5hbWUnDQoNCiAgZGl2IGNsYXNzOiAnZmllbGQnLCAtPg0KICAgIGxhYmVsIGZvcjogJ3Bhc3N3b3JkJywgLT4gJ1Bhc3N3b3JkOiAnDQogICAgaW5wdXQgaWQ6ICdwYXNzd29yZCcsIG5hbWU6ICdwYXNzd29yZCc=')
    atob('aGVhZGVyIC0+DQogIGEgaHJlZjogJy8nLCB0aXRsZTogJ0hvbWUnLCAtPiAnSG9tZScNCg0KICBuYXYgLT4NCgl1bCAtPg0KCSAgZm9yIGl0ZW0gaW4gWydBYm91dCcsICdQcmljaW5nJywgJ0NvbnRhY3QnXQ0KCQlsaSAtPiBhIGhyZWY6ICIvI3tpdGVtLnRvTG93ZXJDYXNlKCl9IiwgdGl0bGU6IGl0ZW0sIC0+IGl0ZW0NCgkJDQoJICBsaSAtPiBhIGhyZWY6ICcvYWJvdXQnLCB0aXRsZTogJ0Fib3V0JywgLT4gJ0Fib3V0Jw0KCSAgbGkgLT4gYSBocmVmOiAnL3ByaWNpbmcnLCB0aXRsZTogJ1ByaWNpbmcnLCAtPiAnUHJpY2luZycNCgkgIGxpIC0+IGEgaHJlZjogJy9jb250YWN0JywgdGl0bGU6ICdDb250YWN0IFVzJywgLT4gJ0NvbnRhY3QgVXMnDQoNCmRpdiBpZDogJ2NvbnRlbnQnLCAtPg0KICBAYm9keQ0KDQpmb290ZXIgLT4NCiAgcCAtPiBhIGhyZWY6ICcvcHJpdmFjeScsIC0+ICdQcml2YWN5IFBvbGljeSc=')
  ])
  css: Queue(["""
    /* Compiled from LESS */
    ul {
      background-color: #000;
    }
    ul li {
      padding: 5px;
    }
    ul li a{
      color: #000;
    }
    ul li a:hover {
      color: #CCC;
      text-decoration: none;
    }
  """, """
    /* Compiled from LESS */
    .menu, .footer {
      border: 1px solid #ddd;
    }
  """])
  less: Queue(["""
    /* Nesting */
    ul {
      background-color: #000;
      li {
        padding: 5px;
        a{
          color: #000;
         :hover {
              color: #CCC;
              text-decoration: none;
          }
        }
      }
    }
  """, """
    /* Selector inheritance */
    .menu {
      border: 1px solid #ddd;
    }

    .footer {
      @extend .menu;
    }
  """, """
    /* Mixin */
    @base: #663333;
    @lighter1: lighten(spin(@base, 5), 10%);
    @lighter2: lighten(spin(@base, 10), 20%);
    @darker1: darken(spin(@base, -5), 10%);
    @darker2: darken(spin(@base, -10), 20%);

    /* Color Scheme */
    .one   {color: @base;}
    .two   {color: @lighter1;}
    .three {color: @lighter2;}
    .four  {color: @darker1;}
    .five  {color: @darker2;}
  """])
  stylus: Queue(["""
    body a
      font 12px/1.3 "Lucida Grande", Arial, sans-serif
      background black
      color #ccc

    form input
      padding 5px
      border 1px solid
  """, """
    // color manipulation

    body
      color darken(#eee, 50)
      color darken(#eee, 50%)
      color #eee - rgba(100,0,0,0.5)
      color rgba(#eee,.5)

    // expression node access

    body
      list = (one 1) (two 2) (three 3)
      foo last(list)

    // pseudo hashes

    get(hash, key)
      return pair[1] if pair[0] == key for pair in hash
  """, """
    // ?= would allow us to define the images global before @importing
    // the file if we were to distribute this

    images ?= '/images'

    image(path)
      url(join('/', images path))

    // or

    image(path)
      url(images + '/' + path)

    body
      background image('foo.png')

    // functions can act as both mixins
    // or have a return value

    image(path)
      if mixin
        background image(path)
      else
        url(images + '/' + path)

    body
      image('something.png')
      background image('something.png')
  """])
  python: Queue(["""
        class Group:
            def __init__(self, name, examples):
                self.title = name
                self.examples = examples

        class Example:
            def __init__(self, expr, name, print=False):
                self.name = name
                self.expr = expr
                if print:
                    self.result = ko.observable(expr)
                else:
                    self.result = ko.observable('')
            def run(self):
                if isinstance(self.expr, list):
                    self.result(''.join(['[', self.expr, ']']))
                else:
                    self.result(self.expr)
        """, """
          caption = 'Wake up, Neo\nFollow the White Rabbit'
          def type(char = 0):
              $("#console").html(caption[0:char])
              if char < len(caption):
                  if caption[char] == "\n":
                      delay = 1280
                  else:
                      delay = 28
                  _.delay(type, delay, char+1)
          type()
        """, """
          pic = $('#images a')
          pic.hide()
          for i, next in pic:
              next.css({'position': 'absolute','left':65*i})
              next.show()
        """, """
          def write():
              for arg in arguments:
                  $('body').append('<span/>'+arg)
          class Behave:
              def __init__(self, name):
                  self.name = name
              def once(self):
                  write('Hello, ', self.name)
              def rename(self, newName):
                  self.name = newName
              def repeat(self, N):
                  for i in range(N): self.once()
          class Subclass(Behave):
              def once(self): write('(', self.name, ')')
          subInstance = Subclass('Queen Bee')
          subInstance.repeat(3)
        """, """
          def scroll():
              global no_oflines, ticker_height, news_height
              no_oflines -= 1
              $('#news_scroller p').css( 'top', ''+no_oflines+'px' )
              if no_oflines<-1*news_height:
                      no_oflines = ticker_height
              window.setTimeout(scroll, 20)

          ticker_height = $('#news_scroller').height()
          news_height=$('#news_scroller p').height()
          no_oflines = 0
          scroll()"""
  ])
  roy: Queue(["""
    let deferred = {
      return: $.when
      bind: \\x f ->
        let defer = $.Deferred ()
        x.done (\\v -> (f v).done defer.resolve)
        defer.promise ()
    }

    let v = do deferred
      hello <- $.ajax 'examples/helloworld.roy'
      alias <- $.ajax 'examples/alias.roy'
      return (hello ++ alias)

    v.done console.log
  """, """
    // Alias for a primitive type
    type Int = Number

    // Alias for a structural type
    type Person = {name: String, age: Int}

    // Function with aliased type annotation
    let personName (p: Person) = p.name
    console.log (personName {name: "Brian", age: 21})

    // Value with aliased type annotation
    let ben: Person = {name: "Ben", age: 18}
    let anyName a = a.name
    console.log (anyName ben)
  """, """
    type Request = {url: String, payload: String}

    let ajaxRequest = {
      return: \\x -> x
      bind: \\(x : Request) f ->
        $.get x.url x.payload f
    }

    let v = (do ajaxRequest
      value <- {url: '/examples/helloworld.roy', payload: 'stuff'}
      console.log value
      return value
    )

    console.log v
  """
  ])
  markdown: Queue(["""
    ### Emphasis ###
    Some of these words *are emphasized*.
    Some of these words _are emphasized also_.

    Use two asterisks for **strong emphasis**.
    Or, if you prefer, __use two underscores instead__.

    ### Code ###
      line 1 of code
      line 2 of code
      line 3 of code

    ### Lists ###
      * An item in a bulleted (unordered) list
          * A subitem, indented with 4 spaces
      * Another item in a bulleted list

  """, """
    A First Level Header
    ====================

    A Second Level Header
    ---------------------

    Now is the time for all good men to come to
    the aid of their country. This is just a
    regular paragraph.

    The quick brown fox jumped over the lazy
    dog's back.

    ### Header 3

    > This is a blockquote.
    >
    > This is the second paragraph in the blockquote.
    >
    > ## This is an H2 in a blockquote
  """
  ])
  jsx: Queue(["""
    var link = function(height = 50, color = 'red', url = 'http://azat.co') {
      ...
    }
  """, """
    var name = `Your name is ${first} ${last}.`
    var url = `http://localhost:3000/api/messages/${id}`
    var roadPoem = `Then took the other, as just as fair,
        And having perhaps the better claim
        Because it was grassy and wanted wear,
        Though as for that the passing there
        Had worn them really about the same,`

    var fourAgreements = `You have the right to be you.
        You can only be you when you do your best.`
  """, """
    var { house, mouse} = $('body').data() // we'll get house and mouse variables

    var {jsonMiddleware} = require('body-parser')

    var {username, password} = req.body
  """, """
    var [col1, col2]  = $('.column'),
    [line1, line2, line3, , line5] = file.split('\n')
  """, """
    var serviceBase = {port: 3000, url: 'azat.co'},
        getAccounts = function(){return [1,2,3]}
    var accountService = {
        __proto__: serviceBase,
        getAccounts,
        toString() {
         return JSON.stringify((super.valueOf()))
        },
        getUrl() {return "http://" + this.url + ':' + this.port},
        [ 'valueOf_' + getAccounts().join('_') ]: getAccounts()
    };
  """, """
    $('.btn').click((event) =>{
      this.sendData()
    })
  """, """
    var wait1000 =  new Promise(function(resolve, reject) {
      setTimeout(resolve, 1000)
    }).then(function() {
      console.log('Yay!')
    })
  """, """
  class baseModel {
    constructor(options = {}, data = []) { // class constructor
          this.name = 'Base'
      this.url = 'http://azat.co/api'
          this.data = data
      this.options = options
      }

      getName() { // class method
          console.log(`Class name: ${this.name}`)
      }
  }
  class AccountModel extends baseModel {
    constructor(options, data) {

    super({private: true}, ['32113123123', '524214691']) //call the parent method with super
        this.name = 'Account Model'
    this.url +='/accounts/'
  }
  """
  ])
  blank: Queue(["""

      """, """

      """, """

      """
  ])

codeMirrorMode = _.memoize((language) ->
  switch language
    when 'html'
      return 'htmlmixed'
    when 'coffeekup'
      return 'coffeescript'
    when 'opal'
      return 'ruby'
    else
      return language
)

descriptions =
  typescript: 'TypeScript is a language for application-scale JavaScript development. It\'s a typed superset of JavaScript that compiles to plain JavaScript.'
  coffeescript: """<p>
      <b>CoffeeScript is a little language that compiles into JavaScript.</b>
      Underneath that awkward Java-esque patina, JavaScript has always had
      a gorgeous heart. CoffeeScript is an attempt to expose
      the good parts of JavaScript in a simple way.
    </p>

    <p>
      The golden rule of CoffeeScript is: <i>"It's just JavaScript"</i>. The code
      compiles one-to-one into the equivalent JS, and there is
      no interpretation at runtime. You can use any existing JavaScript library
      seamlessly from CoffeeScript (and vice-versa). The compiled output is
      readable and pretty-printed, will work in every JavaScript runtime, and tends
      to run as fast or faster than the equivalent handwritten JavaScript.
    </p>"""
  opal: """<p>
    <b>Opal is a Ruby to Javascript compiler</b>
    It is source-to-source, making it fast as a runtime. Opal includes a compiler, a corelib and runtime implementation.
    </p>
    """
  roy: """<p>Roy is an experimental programming language that targets JavaScript. It
        tries to meld JavaScript semantics with some features common in static
        functional languages:</p>
      <ul>
        <li><a href="http://en.wikipedia.org/wiki/Type_inference#Hindley.E2.80.93Milner_type_inference_algorithm">Damas-Hindley-Milner type inference</a></li>
        <li><a href="http://jashkenas.github.com/coffee-script/">Whitespace</a> <a href="http://www.haskell.org/haskellwiki/Haskell">significant</a> <a href="http://www.python.org/">syntax</a></li>
        <li><a href="http://en.wikipedia.org/wiki/Tagged_union">Simple tagged unions</a></li>
        <li><a href="http://en.wikipedia.org/wiki/Pattern_matching">Pattern matching</a></li>
        <li><a href="http://en.wikipedia.org/wiki/Structural_type_system">Structural typing</a></li>
        <li><a href="http://en.wikipedia.org/wiki/Monad_%28functional_programming%29#do-notation">Monad syntax</a></li>
      </ul>
    """
  less: 'Less is a CSS pre-processor, meaning that it extends the CSS language, adding features that allow variables, mixins, functions and many other techniques that allow you to make CSS that is more maintainable, themable and extendable.'
  stylus: """<p>Stylus is a revolutionary new language, providing an efficient, dynamic, and expressive way to generate CSS. Supporting both an indented syntax and regular CSS style.</p>

    <p>Stylus has <em>many</em> features:</p>

    <ul class="task-list">
    <li><a href="/LearnBoost/stylus/blob/master/docs/conditionals.md">conditionals</a></li>
    <li><a href="/LearnBoost/stylus/blob/master/docs/iteration.md">iteration</a></li>
    <li>nested <a href="/LearnBoost/stylus/blob/master/docs/selectors.md">selectors</a>
    </li>
    <li>parent reference</li>
    <li>in-language <a href="/LearnBoost/stylus/blob/master/docs/functions.md">functions</a>
    </li>
    <li><a href="/LearnBoost/stylus/blob/master/docs/vargs.md">variable arguments</a></li>
    <li>built-in <a href="/LearnBoost/stylus/blob/master/docs/bifs.md">functions</a> (over 60)</li>
    <li>optional <a href="/LearnBoost/stylus/blob/master/docs/functions.url.md">image inlining</a>
    </li>
    <li>optional compression</li>
    <li>JavaScript <a href="/LearnBoost/stylus/blob/master/docs/js.md">API</a>
    </li>
    </ul>
    """
  markdown: 'Markdown is a markup language with plain text formatting syntax designed so that it can be converted to HTML and many other formats. Markdown is often used to format readme files, for writing messages in online discussion forums, and to create rich text using a plain text editor.'
  jade: '<p>Jade is a terse language for writing HTML templates.</p><ul><li>Produces HTML</li><li>Supports dynamic code</li><li>Supports reusability (DRY)</li></ul><p>'
  haml: 'Haml (HTML Abstraction Markup Language) is a lightweight markup language that is used to describe the XHTML of any web document without the use of traditional inline coding. It is designed to address many of the flaws in traditional templating engines, as well as making markup as elegant as it can be.'
  coffeekup: 'CoffeeKup uses a simple scheme to provide a concise, expressive, easy-to-read, and time-saving HTML templating solution. It is based on the CoffeeScript language, with which you will need to be familiar. '
  jsx: 'ES6 is an update to JavaScript that adds significant new syntax for writing complex applications, including classes and modules, but defines them semantically in the same terms as ECMAScript 5 strict mode. Other new features include iterators and for/of loops, Python-style generators and generator expressions, arrow functions, binary data, typed arrays, collections (maps, sets and weak maps), promises, number and math enhancements, reflection, and proxies. '
  sass: 'Sass is a CSS pre-processor with syntax advancements. Style sheets in the advanced syntax are processed by the program, and turned into regular CSS style sheets. However, they do not extend the CSS standard itself.'
  scss: 'SCSS is a superset of CSS3’s syntax. This means that every valid CSS3 stylesheet is valid SCSS as well. The second, older syntax is known as the indented syntax (or just “Sass”). Inspired by Haml’s terseness, it’s intended for people who prefer conciseness over similarity to CSS. Instead of brackets and semicolons, it uses the indentation of lines to specify blocks. Although no longer the primary syntax, the indented syntax will continue to be supported.'
  python: """<p>Python is a widely used general-purpose, high-level programming language. Its design philosophy emphasizes code readability, and its syntax allows programmers to express concepts in fewer lines of code than would be possible in languages such as C++ or Java. Python has the following philosopy:</p>
  <ul>
  <li>Beautiful is better than ugly.</li><li>Explicit is better than implicit.</li><li>Simple is better than complex.</li><li>Complex is better than complicated.</li><li>Flat is better than nested.</li><li>Sparse is better than dense.</li><li>Readability counts.</li>
  </ul>"""
  html: 'Hypertext Markup Language, a standardized system for tagging text files to achieve font, color, graphic, and hyperlink effects on World Wide Web pages.'
  css: 'Cascading Style Sheets is a style sheet language used for describing the look and formatting of a document written in a markup language.'
  javascript: 'JavaScript is an object-oriented computer programming language commonly used to create interactive effects within web browsers. '

ViewModel = ->
  settings = Language(if store.get('languages')? then store.get('languages').split(',') else [LANGUAGE.HTML, LANGUAGE.LESS, LANGUAGE.JAVASCRIPT])

  editor = CodeMirror.fromTextArea(document.getElementById('code'),
    readOnly: 'nocursor'
    theme: 'neo'
  )
  $('.CodeMirror-placeholder').remove()

  @timer = null

  @selectedLanguage = store.get('lastSelectedLanguage')
  if @selectedLanguage is LANGUAGE.ZENCODING
    @selectedLanguage = LANGUAGE.HTML

  @documentLanguage = ko.observableArray ['HTML', 'HAML', 'Markdown', 'CoffeeKup', 'Jade']
  @styleLanguage = ko.observableArray ['CSS', 'LESS', 'SCSS', 'SASS', 'Stylus']
  @programLanguage = ko.observableArray ['JavaScript', 'JSX', 'CoffeeScript', 'TypeScript', 'Opal', 'Python', 'Roy']

  camelCase = (name) =>
    for languages in [@documentLanguage(), @styleLanguage(), @programLanguage()]
      for language in languages
        if name is language.toLowerCase()
          return language

  @selectedDocumentLanguage = ko.observable(settings.get_language(LANGUAGE_TYPE.DOCUMENT))
  @selectedStyleLanguage = ko.observable(settings.get_language(LANGUAGE_TYPE.STYLE))
  @selectedProgramLanguage = ko.observable(settings.get_language(LANGUAGE_TYPE.PROGRAM))

  getDescription = (language) ->
    if language of descriptions
      description = descriptions[language]
      if description.charAt(0) isnt '<'
        "<p>#{ description }</p>"
      else
        description
    else
      ''

  @documentLanguageDescription = ko.computed(=> getDescription @selectedDocumentLanguage())
  @styleLanguageDescription = ko.computed(=> getDescription @selectedStyleLanguage())
  @programLanguageDescription = ko.computed(=> getDescription @selectedProgramLanguage())

  @setLanguage = (language) =>
    if language in @documentLanguage()
      @selectedDocumentLanguage(language.toLowerCase())
    else if language in @styleLanguage()
      @selectedStyleLanguage(language.toLowerCase())
    else
      @selectedProgramLanguage(language.toLowerCase())
    properName = language.toLowerCase()
    @setDisplayLanguage(properName)
    @selectedLanguage = properName
    
  @setDisplayLanguage = (language) =>
    editor.setValue examples[language].pop()
    if @timer
      clearInterval @timer
    @timer = setInterval(
      ->
        editor.setValue examples[language].pop()
      5000
    )
    editor.setOption 'mode', codeMirrorMode(language)

  @loadWorkspace = =>
    languages = [ @selectedDocumentLanguage(), @selectedStyleLanguage(), @selectedProgramLanguage() ].join(',')
    store.set 'languages', languages
    # keep the URL the same when the user clicks "Go" without clicking on a language
    store.set 'lastSelectedLanguage', (if @selectedLanguage then @selectedLanguage else @selectedStyleLanguage())
    window.location.assign window.location.href.replace('#', '') + store.get('lastSelectedLanguage') + '/'
  @

viewModel = new ViewModel()
ko.applyBindings viewModel
viewModel.setDisplayLanguage(if debug then 'blank' else viewModel.selectedDocumentLanguage())

$('a[href="#tab-one"]').click( ->
  viewModel.setDisplayLanguage(viewModel.selectedDocumentLanguage())
)

$('a[href="#tab-two"]').click( ->
  viewModel.setDisplayLanguage(viewModel.selectedStyleLanguage())
)

$('a[href="#tab-three"]').click( ->
  viewModel.setDisplayLanguage(viewModel.selectedProgramLanguage())
)

root.viewModel = viewModel