// Get the number of shares on twitter and facebook and add it to the page
// inspired by and built upon share-count.js by the Guardian team
// https://github.com/guardian/frontend/blob/master/static/src/javascripts/projects/common/modules/social/share-count.js

var shareCount = 0,
$shareLabel = $('.social-share-heading'),
$shareCountEls = $('.js-sharecount'),
page = window.location.protocol + "//" + window.location.host + window.location.pathname,
counts = {
  facebook: 'n/a',
  twitter: 'n/a'
};

$sharesNoun = "shares";
if ($shareLabel.attr('data-shares-noun') != undefined) {
  $sharesNoun = $shareLabel.attr('data-shares-noun');
}

function updateShareText() {
    if ($shareLabel.contents().last() !== (" " + $sharesNoun)) {
    $shareLabel.contents().last().remove();
    $shareLabel.append(" " + $sharesNoun);
  }
}

function updateTooltip() {
  var tooltip = 'Facebook: ' + counts.facebook + '\nTwitter: ' + counts.twitter;
  $shareCountEls.attr('title', tooltip);
}

function addToShareCount(val) {
  if (val !== 0) {
    $shareCountEls.addClass("js-sharecount-active");

    var hasRun = false;
    var queries = [
      {
        context: 'small',
        match: function() {
          if (hasRun === false) {
            incrementShareCount(val);
            hasRun = true;
          }
        }
      },
      {
        context: 'wide',
        match: function() {
          if (hasRun === false) {
            var duration = 250,
            updateStep = 25,
            slices = duration / updateStep,
            amountPerStep = val / slices,
            currentSlice = 0,
            interval = window.setInterval(function () {
              incrementShareCount(amountPerStep);
              if (++currentSlice === slices) {
                window.clearInterval(interval);
              }
            }, updateStep);
            hasRun = true;
          }
        }
      }
    ];

    MQ.init(queries);
    updateTooltip();
    updateShareText();
  }
}

function incrementShareCount(amount) {
  if (amount !== 0) {
    shareCount += amount;
    var displayCount = shareCount.toFixed(0);
    $shareCountEls.text(displayCount);
  }
}

function getShareCounts() {
  if ($shareCountEls.length) {
    facebook_url = "https://graph.facebook.com/?ids=" + page +"&callback=?";
    twitter_url = "https://cdn.api.twitter.com/1/urls/count.json?url=" + page + "&callback=?";

    $.getJSON(facebook_url, function(data) {
      var count = data[page].shares || 0;
      counts.facebook = count;
      addToShareCount(counts.facebook);
    });

    $.getJSON(twitter_url, function(data) {
      var count = data.count || 0;
      counts.twitter = count;
      addToShareCount(counts.twitter);
    });
  }
}
