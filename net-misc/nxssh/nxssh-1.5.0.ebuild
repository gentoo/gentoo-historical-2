# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nxssh/nxssh-1.5.0.ebuild,v 1.1 2005/10/20 21:25:37 agriffis Exp $

inherit multilib flag-o-matic

DESCRIPTION="Modified openssh client, used by nxclient"
HOMEPAGE="http://www.nomachine.com/"

IUSE="ipv6 pam tcpd"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

SRC_URI="http://web04.nomachine.com/download/1.5.0/sources/nxssh-$PV-21.tar.gz"

DEPEND="
	=net-misc/nxcomp-1.5*
	dev-libs/openssl
	virtual/libc
	sys-libs/zlib
	tcpd? ( sys-apps/tcp-wrappers )
	pam? ( sys-libs/pam )"

S=${WORKDIR}/${PN}

src_compile() {
	append-ldflags -L/usr/NX/$(get_libdir)
	./configure \
	    --prefix=/usr \
		--sysconfdir=/etc/ssh \
		--mandir=/usr/share/man \
		--libexecdir=/usr/lib/misc \
		--datadir=/usr/share/openssh \
		--disable-suid-ssh \
		--with-privsep-path=/var/empty \
		--with-privsep-user=sshd \
		--with-md5-passwords \
		$(use_with tcpd tcp-wrappers) \
		$(use_with pam) \
		$(use_with !ipv6 ipv4-default) \
		|| die "configure nxssh failed"
	emake || die "emake nxssh failed"
}

src_install() {
	into /usr/NX
	dobin nxssh
}
