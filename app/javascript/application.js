// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
// import "controllers"

import {Apple} from "./apple";
import {Banana} from "./banana";

const apple = new Apple();
apple.say();

const banana = new Banana();
banana.say();
