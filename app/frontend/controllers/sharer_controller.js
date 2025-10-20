import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    imageUrl: String,
    userName: String
  }

  share(event) {
    const shareUrl = this.imageUrlValue;
    const shareText = `Join ${this.userNameValue} in the clouds at @sfrubyconf 🌥️✨`;

    if (navigator.share) {
      navigator
        .share({
          title: `${this.userNameValue}'s Cloud Card`,
          text: shareText,
          url: shareUrl,
        })
        .catch((err) => console.log("Error sharing:", err));
    } else {
      const twitterUrl = `https://x.com/intent/tweet?text=${encodeURIComponent(shareText)}&url=${encodeURIComponent(shareUrl)}&hashtags=SFRubyConf`;
      window.open(twitterUrl, "_blank", "width=550,height=420");
    }
  }
}
