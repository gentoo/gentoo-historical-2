# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/capisuite/capisuite-0.4.5-r2.ebuild,v 1.1 2005/06/20 20:26:54 sbriesen Exp $

inherit eutils python

DESCRIPTION="ISDN telecommunication suite providing fax and voice services"
HOMEPAGE="http://www.capisuite.de"
SRC_URI="http://www.capisuite.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND="virtual/python
	virtual/libc
	sys-devel/automake
	>=sys-devel/autoconf-2.50
	media-sound/sox
	media-libs/tiff
	media-gfx/jpeg2ps
	media-gfx/sfftobmp
	virtual/ghostscript"
RDEPEND="${DEPEND}
	net-dialup/capi4k-utils
	virtual/mta"

src_unpack() {
	unpack ${A}
	cd ${S}

	# taken from capisuite-0.4.5-5.src.rpm (SuSE-9.3)
	epatch ${FILESDIR}/${P}-capi4linux_v3.diff

	# patched scripts/cs_helpers.pyin for bug #96540
	epatch ${FILESDIR}/${P}-date-header.patch

	# patched src/backend/connection.cpp for bug #69522
	epatch ${FILESDIR}/${PN}-fax-compatibility.patch
}

src_compile() {
	ebegin "Updating autotools-generated files"
	aclocal -I . || die "aclocal failed"
	automake -a || die "automake failed"
	autoheader || die "autoheader failed"
	WANT_AUTOCONF=2.5 autoconf || die "autoconf failed"
	eend $?

	econf --localstatedir=/var \
		--with-docdir=/usr/share/doc/${PF} || die "econf failed."
	emake || die "parallel make failed."
}

src_install() {
	make DESTDIR=${D} install || die "install failed."

	rm -f ${D}/usr/{lib,share}/capisuite/README
	rmdir -p --ignore-fail-on-non-empty ${D}/var/log
	rm -f ${D}/usr/share/doc/${PF}/{COPYING,manual.pdf}
	keepdir /var/spool/capisuite/{done,failed,sendq,users}

	dodir /etc/init.d
	newinitd ${FILESDIR}/capisuite.initd capisuite

	insinto /etc/logrotate.d
	newins ${FILESDIR}/capisuite.logrotated capisuite

	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO

	exeinto /etc/cron.daily
	doexe capisuite.cron

	insinto /etc/capisuite
	doins cronjob.conf
}

pkg_postinst() {
	python_version
	python_mod_compile ${ROOT}usr/lib/python${PYVER}/site-packages/cs_helpers.py
}

pkg_postrm() {
	python_version
	python_mod_cleanup ${ROOT}usr/lib/python${PYVER}/site-packages
}
