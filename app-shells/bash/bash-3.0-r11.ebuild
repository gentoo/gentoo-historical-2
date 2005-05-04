# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/bash/bash-3.0-r11.ebuild,v 1.6 2005/05/04 05:28:44 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs

# Official patchlevel
# See ftp://ftp.cwru.edu/pub/bash/bash-3.0-patches/
PLEVEL=16

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://cnswww.cns.cwru.edu/~chet/bash/bashtop.html"
# Hit the GNU mirrors before hitting Chet's site
SRC_URI="mirror://gnu/bash/${P}.tar.gz
	ftp://ftp.cwru.edu/pub/bash/${P}.tar.gz
	mirror://gentoo/${P}-gentoo.diff.bz2
	$(for ((i=1; i<=PLEVEL; i++)); do
		printf 'ftp://ftp.cwru.edu/pub/bash/bash-%s-patches/bash%s-%03d\n' \
			${PV} ${PV/\.} ${i}
		printf 'mirror://gnu/bash/bash-%s-patches/bash%s-%03d\n' \
			${PV} ${PV/\.} ${i}
	done)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls build bashlogger"

# we link statically with ncurses
DEPEND=">=sys-libs/ncurses-5.2-r2"
RDEPEND=""

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	epatch "${DISTDIR}"/${P}-gentoo.diff.bz2

	# Remove autoconf dependency
	sed -i -e "/&& autoconf/d" Makefile.in

	# Include official patches
	local i
	for ((i=1; i<=PLEVEL; i++)); do
		epatch "${DISTDIR}"/${PN}${PV/\.}-$(printf '%03d' ${i})
	done

	# Patch readline's bind.c so that /etc/inputrc is read as a last resort
	# following ~/.inputrc.  This is better than putting INPUTRC in
	# the environment because INPUTRC will override even after the
	# user creates a ~/.inputrc
	epatch "${FILESDIR}"/${P}-etc-inputrc.patch
	# Fix network tests on Darwin #79124
	epatch "${FILESDIR}"/${P}-darwin-conn.patch
	# A bunch of fixes from fedora
	epatch "${FILESDIR}"/${P}-{afs,crash,jobs,manpage,pwd,read-e-segfault,ulimit}.patch
	# Fix read-builtin and the -u pipe option #87093
	epatch "${FILESDIR}"/${P}-read-builtin-pipe.patch
	# Don't barf on handled signals in scripts
	epatch "${FILESDIR}"/${P}-trap-fg-signals.patch
	# Log bash commands to syslog #91327
	if use bashlogger ; then
		echo
		ewarn "The logging patch should ONLY be used in restricted (i.e. honeypot) envs."
		ewarn "This will log ALL output you enter into the shell, you have been warned."
		ebeep
		epause
		epatch "${FILESDIR}"/${P}-bash-logger.patch
	fi

	# Enable SSH_SOURCE_BASHRC (#24762)
	echo '#define SSH_SOURCE_BASHRC' >> config-top.h
	# Enable system-wide bashrc (#26952)
	echo '#define SYS_BASHRC "/etc/bash/bashrc"' >> config-top.h
	# Enable system-wide logout (#90488)
	echo '#define SYS_BASH_LOGOUT "/etc/bash/bash_logout"' >> config-top.h

	# Force pgrp synchronization
	# (https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=81653)
	#
	# The session will hang cases where you 'su' (not 'su -') and
	# then run a piped command in emacs.
	# This problem seem to happen due to scheduler changes kernel
	# side - although reproduceble with later 2.4 kernels, it is
	# especially easy with 2.6 kernels.
	echo '#define PGRP_PIPE 1' >> config-bot.h

	sed -i 's:-lcurses:-lncurses:' configure || die "sed configure"
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

	echo 'int main(){}' > "${T}"/term-test.c
	if ! $(tc-getCC) -static -lncurses "${T}"/term-test.c 2> /dev/null ; then
		export bash_cv_termcap_lib=gnutermcap
	else
		export bash_cv_termcap_lib=libcurses
		myconf="${myconf} --with-ncurses"
	fi

	econf \
		--disable-profiling \
		--without-gnu-malloc \
		${myconf} || die
	# Make sure we always link statically with ncurses
	sed -i "/^TERMCAP_LIB/s:-lncurses:-Wl,-Bstatic -lncurses -Wl,-Bdynamic:" Makefile || die "sed failed"
	emake || die "make failed"
}

src_install() {
	einstall || die

	dodir /bin
	mv "${D}"/usr/bin/bash "${D}"/bin/
	[[ ${USERLAND} != "BSD" ]] && dosym bash /bin/sh
	dosym bash /bin/rbash

	insinto /etc/bash
	doins "${FILESDIR}"/{bashrc,bash_logout}
	insinto /etc/skel
	for f in bash{_logout,_profile,rc} ; do
		newins "${FILESDIR}"/dot-${f} .${f}
	done

	if use build ; then
		rm -rf "${D}"/usr
	else
		doman doc/*.1
		dodoc README NEWS AUTHORS CHANGES COMPAT Y2K doc/FAQ doc/INTRO
		dosym bash.info.gz /usr/share/info/bashref.info.gz
	fi
}

pkg_preinst() {
	if [[ -e ${ROOT}/etc/bashrc ]] && [[ ! -d ${ROOT}/etc/bash ]] ; then
		mkdir -p "${ROOT}"/etc/bash
		mv -f "${ROOT}"/etc/bashrc "${ROOT}"/etc/bash/
	fi

	# our bash_logout is just a place holder so dont 
	# force users to go through etc-update all the time
	if [[ -e ${ROOT}/etc/bash/bash_logout ]] ; then
		rm -f "${D}"/etc/bash/bash_logout
	fi
}
