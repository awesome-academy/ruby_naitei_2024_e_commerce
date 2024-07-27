$(document).ready(function () {
    var autoLoad = setInterval(() => {
        $('#btn-next').trigger('click');
    }, 3000);

        $('#btn-next').click(function (e) {
            var nextSlide = $('.actived').next();
            var nowPosition = $('.node--actived').index() + 1;
            if (nextSlide.length != 0) {
                $('.actived').addClass('disappearLeft').one('webkitAnimationEnd', function (e) {
                    $('.disappearLeft').removeClass('disappearLeft').removeClass('actived');
                });
                nextSlide.addClass('actived').addClass('slideInRight').one('webkitAnimationEnd', function (e) {
                    $('.slideInRight').removeClass('slideInRight');
                });

                $('.slider__interaction ul li').removeClass('node--actived');
                $('.slider__interaction ul li:nth-child(' + (nowPosition + 1) + ')').addClass('node--actived');
            } else {
                $('.actived').addClass('disappearLeft').one('webkitAnimationEnd', function (e) {
                    $('.disappearLeft').removeClass('disappearLeft').removeClass('actived');
                });
                $('.slide:first-child').addClass('actived').addClass('slideInRight').one('webkitAnimationEnd', function (e) {
                    $('.slideInRight').removeClass('slideInRight');
                });

                $('.slider__interaction ul li').removeClass('node--actived');
                $('.slider__interaction ul li:nth-child(1)').addClass('node--actived');
            }
        });

        $('#btn-prev').click(function (e) {
            var prevSlide = $('.actived').prev();
            var nowPosition = $('.node--actived').index() + 1;
            if (prevSlide.length != 0) {
                $('.actived').addClass('disappearRight').one('webkitAnimationEnd', function (e) {
                    $('.disappearRight').removeClass('disappearRight').removeClass('actived');
                });
                prevSlide.addClass('actived').addClass('slideInLeft').one('webkitAnimationEnd', function (e) {
                    $('.slideInLeft').removeClass('slideInLeft');
                });;

                $('.slider__interaction ul li').removeClass('node--actived');
                $('.slider__interaction ul li:nth-child(' + (nowPosition - 1) + ')').addClass('node--actived');
            } else {
                $('.actived').addClass('disappearRight').one('webkitAnimationEnd', function (e) {
                    $('.disappearRight').removeClass('disappearRight').removeClass('actived');
                });
                $('.slide:last-child').addClass('actived').addClass('slideInLeft').one('webkitAnimationEnd', function (e) {
                    $('.slideInLeft').removeClass('slideInLeft');
                });;

                $('.slider__interaction ul li').removeClass('node--actived');
                $('.slider__interaction ul li:last-child').addClass('node--actived');
            }
        });

    $('.slider__interaction ul li').click(function (e) {
        var nowPosition = $('.node--actived').index() + 1;
        var thisPosition = $(this).index() + 1;
        $('.slider__interaction ul li').removeClass('node--actived');
        $(this).addClass('node--actived');
        if (thisPosition > nowPosition) {
            $('.actived').addClass('disappearLeft').one('webkitAnimationEnd', function(e) {
                $('.disappearLeft').removeClass('disappearLeft').removeClass('actived');
            });
            $('.slide:nth-child('+thisPosition+')').addClass('actived').addClass('slideInRight').one('webkitAnimationEnd', function(e) {
                $('.slideInRight').removeClass('slideInRight');
            });
        } else {
            $('.actived').addClass('disappearRight').one('webkitAnimationEnd', function(e) {
                $('.disappearRight').removeClass('disappearRight').removeClass('actived');
            });
            $('.slide:nth-child('+thisPosition+')').addClass('actived').addClass('slideInLeft').one('webkitAnimationEnd', function(e) {
                $('.slideInLeft').removeClass('slideInLeft');
            });
        }
    });
});
