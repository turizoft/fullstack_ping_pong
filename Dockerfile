FROM ruby:2.2.6
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /fullstack_labs_exercise
WORKDIR /fullstack_labs_exercise
ADD Gemfile /fullstack_labs_exercise/Gemfile
ADD Gemfile.lock /fullstack_labs_exercise/Gemfile.lock
RUN bundle install
ADD . /fullstack_labs_exercise