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

    new WOW().init();

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

    /* Hero Floating Protein Animation Interactivity */
    var $heroShaker = $('#proteinShakerHero');
    if ($heroShaker.length) {
        // Interactive Click - Spawn Extra Powder Particles Burst
        $heroShaker.on('click', function (e) {
            var $trail = $('.powder-trail-container');
            for (var i = 0; i < 6; i++) {
                var $p = $('<div class="powder-particle"></div>');
                var offsetX = (Math.random() - 0.5) * 60;
                var offsetY = (Math.random() - 0.5) * 60;
                var size = Math.floor(Math.random() * 10) + 8;
                
                $p.css({
                    width: size + 'px',
                    height: size + 'px',
                    top: '48%',
                    left: '35%',
                    transform: 'translate(' + offsetX + 'px, ' + offsetY + 'px)'
                });
                
                $trail.append($p);
                (function($elem) {
                    setTimeout(function () {
                        $elem.remove();
                    }, 2800);
                })($p);
            }

            // Quick boost shake effect
            $heroShaker.addClass('animate__animated animate__rubberBand');
            setTimeout(function () {
                $heroShaker.removeClass('animate__animated animate__rubberBand');
            }, 1000);
        });

        // Mouse Move Parallax Tilt inside Hero Viewport
        $('#header-carousel').on('mousemove', function (e) {
            var rect = this.getBoundingClientRect();
            var x = (e.clientX - rect.left) / rect.width - 0.5;
            var y = (e.clientY - rect.top) / rect.height - 0.5;

            var tiltX = y * -20;
            var tiltY = x * 20;

            $('.protein-bobbing-wrapper').css({
                'transform': 'perspective(600px) rotateX(' + tiltX + 'deg) rotateY(' + tiltY + 'deg)'
            });
        }).on('mouseleave', function () {
            $('.protein-bobbing-wrapper').css({
                'transform': 'none'
            });
        });
    }
})(jQuery);

