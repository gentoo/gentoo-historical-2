# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/metalog/metalog-0.6-r10.ebuild,v 1.11 2002/12/10 20:08:35 wwoods Exp $

DESCRIPTION="A highly configurable replacement for syslogd/klogd"
SRC_URI="mirror://sourceforge/metalog/${P}.tar.gz"
HOMEPAGE="http://metalog.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha"

DEPEND=">=dev-libs/libpcre-3.4"

src_unpack() {
	unpack ${A} ; cd ${S}
	# adds a pidfile option.  NiCE aeoo! :)
	patch -p1 < ${FILESDIR}/metalog-0.6-gentoo.patch || die
	cd ${S}/src
	mv metalog.h metalog.h.orig
	sed -e "s:/etc/metalog.conf:/etc/metalog/metalog.conf:g" \
		metalog.h.orig > metalog.h
	cd ${S}/man
	mv metalog.8 metalog.8.orig
	sed -e "s:/etc/metalog.conf:/etc/metalog/metalog.conf:g" \
		metalog.8.orig > metalog.8
}

src_compile() {
	econf
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog README
	newdoc metalog.conf metalog.conf.sample

	insinto /etc/metalog ; doins ${FILESDIR}/metalog.conf
	exeinto /etc/init.d ; newexe ${FILESDIR}/metalog.rc6 metalog
	insinto /etc/conf.d ; newins ${FILESDIR}/metalog.confd metalog
	
	exeinto /usr/sbin
	doexe ${FILESDIR}/consolelog.sh
}
