FROM amazonlinux:2

ENV PHPENV_ROOT  /root/.phpenv
ENV LIBRARY_DIR /usr/local/src
RUN yum install -y git
RUN git clone git://github.com/phpenv/phpenv.git ${PHPENV_ROOT}
RUN git clone https://github.com/php-build/php-build ${PHPENV_ROOT}/plugins/php-build
RUN yum install -y \
      tar \
      libxml2 \
      libxml2-devel \
      bzip2 \
      bzip2-devel \
      curl-devel \
      libjpeg-devel \
      libpng-devel \
      readline-devel \
      libxslt-devel \
      libtool-ltdl-devel \
      openssl-devel \
      gcc \
      make \
      httpd \
      httpd-devel \
      autoconf \
      help2man \
      re2c \
      flex \
      mysql-devel \
      libtidy \
      libtidy-devel \
      wget \
      vim

RUN amazon-linux-extras install -y epel
RUN yum install -y --enablerepo=epel libmcrypt libmcrypt-devel
RUN cd ${LIBRARY_DIR} \
      && wget https://ftp.gnu.org/gnu/bison/bison-2.4.1.tar.gz \
      && tar -xzvf bison-2.4.1.tar.gz \
      && cd bison-2.4.1/ \
      && ./configure


RUN cd ${LIBRARY_DIR} \
      && wget https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz \
      && tar -xzvf m4-1.4.18.tar.gz \
      && cd m4-1.4.18 \
      && ./configure \
      && make \
      && make install

RUN cd ${LIBRARY_DIR}/bison-2.4.1 \
      && make \
      && make install

COPY ./01php-5.2.17.patch ${PHPENV_ROOT}/plugins/php-build/share/php-build/patches/
COPY ./00php-5.2.17-for-apache.2.4.patch ${PHPENV_ROOT}/plugins/php-build/share/php-build/patches/

COPY ./00-base.conf /etc/httpd/conf.modules.d/00-base.conf
COPY ./httpd.conf /etc/httpd/conf/httpd.conf

COPY ./5.2.17 ${PHPENV_ROOT}/plugins/php-build/share/php-build/definitions/5.2.17
COPY ./sed_unixd.sh ${PHPENV_ROOT}/plugins/php-build/share/php-build/before-install.d/
RUN chmod +x ${PHPENV_ROOT}/plugins/php-build/share/php-build/before-install.d/sed_unixd.sh

RUN echo '' >> /etc/profile
ENV PATH /root/.phpenv/bin:$PATH

SHELL ["/bin/bash", "-c"]
RUN env

RUN yum install -y libtidy libtidy-devel patch
RUN rm -rf /tmp/php-build
RUN phpenv install 5.2.17
RUN set -eux; \
	{ \
		eval "$(phpenv init -)"; \
		phpenv global 5.2.17; \
	}
COPY ./index.php /var/www/html/index.php

CMD [ "/usr/sbin/httpd", "-D", "FOREGROUND" ]

