(function ($) {
    "use strict";

    var spinner = function () {
        setTimeout(function () {
            if ($('#spinner').length > 0) {
                $('#spinner').removeClass('show');
            }
        }, 500);
    };
    spinner();

    $(window).scroll(function () {
        var scrollTop = $(this).scrollTop();
        $('.scroll-progress').css('width', (scrollTop / ($(document).height() - $(window).height())) * 100 + '%');

        if (scrollTop > 45) {
            $('.fixed-top').addClass('scrolled');
        } else {
            $('.fixed-top').removeClass('scrolled');
        }

        if (scrollTop > 300) {
            $('.back-to-top').fadeIn('slow');
        } else {
            $('.back-to-top').fadeOut('slow');
        }
    });

    $('.back-to-top').click(function () {
        $('html, body').animate({scrollTop: 0}, 1400, 'easeInOutExpo');
        return false;
    });

    $('.testimonial-carousel').owlCarousel({
        autoplay: true,
        smartSpeed: 1000,
        margin: 25,
        loop: true,
        center: true,
        dots: false,
        nav: true,
        navText : [
            '<i class="bi bi-chevron-left"></i>',
            '<i class="bi bi-chevron-right"></i>'
        ],
        responsive: {
            0:{ items:1 },
            768:{ items:2 },
            992:{ items:3 }
        }
    });

    $('.counter').each(function () {
        var $this = $(this);
        var countTo = parseInt($this.attr('data-count')) || 0;
        $({ countNum: 0 }).animate({ countNum: countTo }, {
            duration: 1600,
            easing: 'swing',
            step: function () {
                $this.text(Math.floor(this.countNum));
            },
            complete: function () {
                $this.text(this.countNum);
            }
        });
    });

    $('.wishlist-toggle').on('click', function (e) {
        e.preventDefault();
        $(this).toggleClass('active');
    });

    if ($('.countdown').length) {
        var countdownDate = new Date().getTime() + 1000 * 60 * 60 * 48;
        var countdownTimer = setInterval(function () {
            var now = new Date().getTime();
            var distance = countdownDate - now;
            var days = Math.floor(distance / (1000 * 60 * 60 * 24));
            var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((distance % (1000 * 60)) / 1000);

            $('.countdown').html('<span class="countdown-box">' + days + 'd</span><span class="countdown-box">' + hours + 'h</span><span class="countdown-box">' + minutes + 'm</span><span class="countdown-box">' + seconds + 's</span>');

            if (distance < 0) {
                clearInterval(countdownTimer);
                $('.countdown').html('<span class="countdown-box">Offer ended</span>');
            }
        }, 1000);
    }

})(jQuery);

