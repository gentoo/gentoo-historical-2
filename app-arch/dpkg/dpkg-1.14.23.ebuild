# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/dpkg/dpkg-1.14.23.ebuild,v 1.1 2008/11/27 22:48:57 jer Exp $

inherit eutils multilib

DESCRIPTION="Package maintenance system for Debian"
HOMEPAGE="http://packages.qa.debian.org/dpkg"
SRC_URI="mirror://debian/pool/main/d/dpkg/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~s390 ~sh ~sparc ~x86"
IUSE="bzip2 nls selinux test unicode zlib"

RDEPEND=">=dev-lang/perl-5.6.0
	dev-perl/TimeDate
	>=sys-libs/ncurses-5.2-r7
	zlib? ( >=sys-libs/zlib-1.1.4 )
	bzip2? ( app-arch/bzip2 )"
DEPEND="${RDEPEND}
	nls? ( app-text/po4a )
	test? ( dev-perl/Test-Pod )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.14.12-nls.patch #192819
	if ! use unicode ; then
		sed -i "s:ncursesw/::" dselect/{Makefile.in,dselect.h,main.cc} #217046
		export ac_cv_lib_ncursesw_initscr=no
	fi
}

src_compile() {
	econf \
		$(use_with bzip2 bz2lib) \
		$(use_enable nls) \
		$(use_with selinux) \
		$(use_with zlib) \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	rm "${D}"/usr/sbin/{install-info,start-stop-daemon}
	rm "${D}"/usr/share/man/man?/{install-info,start-stop-daemon}.?
	dodoc ChangeLog INSTALL THANKS TODO
	keepdir /usr/$(get_libdir)/db/methods/{mnt,floppy,disk}
	keepdir /usr/$(get_libdir)/db/{alternatives,info,methods,parts,updates}
}
