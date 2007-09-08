# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/automake/automake-1.5.ebuild,v 1.29 2007/09/08 06:46:28 vapier Exp $

inherit eutils

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="http://sources.redhat.com/automake/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="${PV:0:3}"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl
	sys-devel/automake-wrapper
	>=sys-devel/autoconf-2.59-r6
	sys-devel/gnuconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/automake-1.4-nls-nuisances.patch #121151
	epatch "${FILESDIR}"/${P}-target_hook.patch
	epatch "${FILESDIR}"/${P}-slot.patch
	epatch "${FILESDIR}"/${P}-test-fixes.patch #79505
	sed -i \
		-e "/^@setfilename/s|automake|automake${SLOT}|" \
		-e "s|automake: (automake)|automake v${SLOT}: (automake${SLOT})|" \
		-e "s|aclocal: (automake)|aclocal v${SLOT}: (automake${SLOT})|" \
		automake.texi || die "sed failed"
	export WANT_AUTOCONF=2.5
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed"

	local x=
	for x in aclocal automake ; do
		mv "${D}"/usr/bin/${x}{,-${SLOT}} || die "rename ${x}"
		mv "${D}"/usr/share/${x}{,-${SLOT}} || die "move ${x}"
	done

	dodoc NEWS README THANKS TODO AUTHORS ChangeLog
	doinfo *.info

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} /usr/share/${PN}-${SLOT}/config.${x}
	done
}
