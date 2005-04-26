# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/leafnode/leafnode-1.11.1.ebuild,v 1.1 2005/04/26 21:44:08 swegener Exp $

MY_P=${P}.rel

DESCRIPTION="A USENET software package designed for small sites"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
HOMEPAGE="http://leafnode.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE="ipv6"

DEPEND=">=dev-libs/libpcre-3.9"
RDEPEND="${DEPEND}
	virtual/inetd"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf \
		--sysconfdir=/etc/leafnode \
		--localstatedir=/var \
		--with-spooldir=/var/spool/news \
		$(use_with ipv6) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	keepdir \
		/var/lock/news \
		/var/lib/news \
		/var/spool/news/{failed.postings,interesting.groups,leaf.node,out.going,temp.files} \
		/var/spool/news/message.id/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}

	chown -R news:news ${D}/var/lib/news ${D}/var/spool/news

	insinto /etc/xinetd.d
	newins ${FILESDIR}/leafnode.xinetd leafnode-nntp

	exeinto /etc/cron.hourly
	newexe ${FILESDIR}/fetchnews.cron fetchnews
	exeinto /etc/cron.daily
	newexe ${FILESDIR}/texpire.cron texpire

	dodoc \
		CREDITS ChangeLog FAQ.txt FAQ.pdf INSTALL NEWS \
		README.FIRST README-daemontools UNINSTALL-daemontools \
		README README-MAINTAINER README-FQDN
	dohtml FAQ.html FAQ.xml README-FQDN.html
}
