# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/tar/tar-1.14.90.ebuild,v 1.5 2004/10/11 04:26:13 seemant Exp $

inherit flag-o-matic eutils gnuconfig

DESCRIPTION="Use this to make tarballs :)"
HOMEPAGE="http://www.gnu.org/software/tar/"
SRC_URI="http://dev.gentoo.org/~seemant/distfiles/${P}.tar.bz2
	http://alpha.gnu.org/gnu/tar/${P}.tar.bz2
	mirror://gnu/tar/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="nls static build"

DEPEND="virtual/libc
	app-arch/gzip
	app-arch/bzip2
	app-arch/ncompress"
RDEPEND="${DEPEND}
	nls? ( >=sys-devel/gettext-0.10.35 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-remote-shell.patch
	epatch ${FILESDIR}/${PV}-tests.patch
	gnuconfig_update
	use static && append-ldflags -static
}

src_compile() {
	econf \
		--disable-dependency-tracking \
		--bindir=/bin \
		--libexecdir=/usr/sbin \
		$(use_enable nls) || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	# a nasty yet required symlink:
	dodir /etc
	dosym ../usr/sbin/rmt /etc/rmt
	if use build ; then
		rm -rf ${D}/usr
	else
		dodoc AUTHORS ChangeLog* NEWS README* PORTS THANKS
		doman "${FILESDIR}/tar.1"
	fi
}
