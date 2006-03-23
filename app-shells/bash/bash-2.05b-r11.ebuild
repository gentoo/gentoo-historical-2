# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/bash/bash-2.05b-r11.ebuild,v 1.11 2006/03/23 23:07:21 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs

# Official patches
PLEVEL="x002 x003 x004 x005 x006 x007"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://cnswww.cns.cwru.edu/~chet/bash/bashtop.html"
SRC_URI="mirror://gnu/bash/${P}.tar.gz
	mirror://gentoo/${P}-gentoo.diff.bz2
	${PLEVEL//x/mirror://gnu/bash/bash-${PV}-patches/bash${PV/\.}-}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="nls build minimal"

# we link statically with ncurses
DEPEND=">=sys-libs/ncurses-5.2-r2"
RDEPEND=""

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}"
	epatch "${DISTDIR}"/${P}-gentoo.diff.bz2

	for x in ${PLEVEL//x}
	do
		epatch "${DISTDIR}"/${PN}${PV/\.}-${x}
	done

	# Remove autoconf dependency
	sed -i -e "/&& autoconf/d" Makefile.in

	# Readline is slow with multibyte locale, bug #19762
	epatch "${FILESDIR}"/${P}-multibyte-locale.patch
	# Segfault on empty herestring
	epatch "${FILESDIR}"/${P}-empty-herestring.patch
	# Fix broken rbash functionality
	epatch "${FILESDIR}"/${P}-rbash.patch
	# Fix parallel make, bug #41002.
	epatch "${FILESDIR}"/${P}-parallel-build.patch
	# Fix using bash with post-20040808 glibc ebuilds (from fedora)
	epatch "${FILESDIR}"/${P}-jobs.patch
	# Fix bash call to setlocale #64266
	epatch "${FILESDIR}"/${P}-setlocale.patch

	# Enable SSH_SOURCE_BASHRC (#24762)
	echo '#define SSH_SOURCE_BASHRC' >> config-top.h

	# Enable system-wide bashrc (#26952)
	echo '#define SYS_BASHRC "/etc/bash/bashrc"' >> config-top.h

	# Force pgrp synchronization
	# (https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=81653)
	#
	# The session will hang cases where you 'su' (not 'su -') and
	# then run a piped command in emacs.
	# This problem seem to happen due to scheduler changes kernel
	# side - although reproduceble with later 2.4 kernels, it is
	# especially easy with 2.6 kernels.
	echo '#define PGRP_PIPE 1' >> config-bot.h
}

src_compile() {
	filter-flags -malign-double

	local myconf=

	# Always use the buildin readline, else if we update readline
	# bash gets borked as readline is usually not binary compadible
	# between minor versions.
	#
	# Martin Schlemmer <azarah@gentoo.org> (1 Sep 2002)
	#use readline && myconf="--with-installed-readline"

	# Don't even think about building this statically without
	# reading Bug 7714 first.  If you still build it statically,
	# don't come crying to use with bugs ;).
	#use static && export LDFLAGS="${LDFLAGS} -static"
	use nls || myconf="${myconf} --disable-nls"

	# Force linking with system curses ... the bundled termcap lib
	# sucks bad compared to ncurses
	myconf="${myconf} --with-curses"

	econf \
		--disable-profiling \
		--without-gnu-malloc \
		${myconf} || die
	emake || die "make failed"
}

src_install() {
	einstall || die

	dodir /bin
	mv ${D}/usr/bin/bash ${D}/bin
	dosym bash /bin/sh
	dosym bash /bin/rbash

	use minimal && rm -f ${D}/usr/bin/bashbug ${D}/usr/share/man*/bashbug*

	insinto /etc/bash
	doins "${FILESDIR}"/bashrc

	if use build; then
		rm -rf ${D}/usr
	else
		doman doc/*.1
		dodoc README NEWS AUTHORS CHANGES COMPAT Y2K
		dodoc doc/FAQ doc/INTRO

		dosym bash.info.gz /usr/share/info/bashref.info.gz
	fi
}
