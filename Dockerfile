FROM centos:centos7
RUN yum makecache \
    && yum -y update \
    && yum install -y \
       curl ca-certificates gnupg2 \
       which gcc-c++ make patch readline zlib \
       mod_ssl make bzip2 autoconf \
       automake libtool bison sqlite-devel mysql-devel \
       vim git

# nodejs
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash -
RUN yum install -y nodejs mutt

# yarn
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
RUN rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
RUN yum -y install yarn unzip

# other packages
RUN mkdir /root/packages
WORKDIR /root/packages/
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip ; ./aws/install
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
RUN curl -L get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN rvm reload
RUN yum -y remove ruby
RUN /bin/bash -l -c "rvm install 3.1.0"
RUN /bin/bash -l -c "rvm use 3.1.0 --default"
RUN /bin/bash -l -c "gem install bundler"
ENV PATH /usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:$PATH
RUN mkdir /React_Project
WORKDIR /React_Project
COPY Gemfile /React_Project/Gemfile
# COPY Gemfile.lock /myapp/Gemfile.lock
RUN ["/bin/bash", "-l", "-c", "bundle install"]
RUN yum clean all
