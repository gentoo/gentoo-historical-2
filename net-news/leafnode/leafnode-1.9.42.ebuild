# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/leafnode/leafnode-1.9.42.ebuild,v 1.3 2003/10/21 21:19:58 mholzer Exp $

S=${WORKDIR}/${P}.rel
DESCRIPTION="leafnode - A USENET software package designed for small sites"
SRC_URI="mirror://sourceforge/leafnode/${P}.rel.tar.bz2"
HOMEPAGE="http://www.leafnode.org"
RESTRICT="nomirror"
DEPEND=">=dev-libs/libpcre-3.9
	virtual/inetd"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="ipv6"

src_compile() {
	use ipv6 && myconf="--with-ipv6"

	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--sysconfdir=/etc/leafnode \
		--localstatedir=/var \
		${myconf} || die "./configure failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	# remove the spool dirs -- put them back in during pkg_postinst, so that
	# they don't get removed during an unmerge or upgrade
	rm -rf ${D}/var/spool

	# add .keep file to /var/lock/news to avoid ebuild to ignore the empty dir
	keepdir /var/lock/news/

	insinto /etc/xinetd.d
	newins ${FILESDIR}/leafnode.xinetd leafnode-nntp

	exeinto /etc/cron.hourly
	doexe ${FILESDIR}/fetchnews.cron
	exeinto /etc/cron.daily
	doexe ${FILESDIR}/texpire.cron

	dodoc COPYING* CREDITS ChangeLog FAQ.txt FAQ.pdf INSTALL NEWS \
	TODO README.FIRST README-daemontools UNINSTALL-daemontools \
	README README-MAINTAINER README-FQDN PCRE_README
	dohtml FAQ.html FAQ.xml README-FQDN.html
}

pkg_postinst() {
	mkdir -p /var/spool/news/{leaf.node,failed.postings,interesting.groups,out.going}
	mkdir -p /var/spool/news/message.id/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
	chown -R news:news /var/spool/news
	cat ${S}/README.FIRST
}
