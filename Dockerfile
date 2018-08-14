FROM centos:centos7

LABEL maintainer Chris Collins <collins.christopher@gmail.com>
LABEL name "chn-server"
LABEL version "0.1"
LABEL release "2"
LABEL summary "Community Honey Network Server"
LABEL description "Multi-snort and honeypot sensor management, uses a network of VMs, small footprint SNORT installations, stealthy dionaeas, and a centralized server for management."
LABEL authoritative-source-url "https://github.com/CommunityHoneyNetwork/communityhoneynetwork"
LABEL changelog-url "https://github.com/CommunityHoneyNetwork/communityhoneynetwork/commits/master"

ENV pkgs "git gcc python2-pip python2-devel GeoIP-devel sqlite-devel redis"
ENV user "chn"
ENV workdir "/home/${user}"

RUN yum install -y epel-release \
      && yum install -y $pkgs \
      && yum clean all \
      && rm -rf /var/cache/yum

RUN pip --no-cache-dir install --upgrade pip

RUN useradd $user \
      && usermod -aG users $user

COPY chnserver /home/${user}/

RUN chown -R $user $workdir

USER $user
WORKDIR $workdir

# This is set in the config.py, but hardcodes in the template
# for it.  Can we abstract this?
RUN mkdir ${workdir}/sqlite

RUN pip --no-cache-dir install --user -r requirements.txt

CMD [ "python", "init_uwsgi.py" ]
