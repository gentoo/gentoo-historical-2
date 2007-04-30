# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/coreutils/coreutils-6.9-r1.ebuild,v 1.1 2007/04/30 18:55:59 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs autotools

PATCH_VER="1.2"
DESCRIPTION="Standard GNU file utilities (chmod, cp, dd, dir, ls...), text utilities (sort, tr, head, wc..), and shell utilities (whoami, who,...)"
HOMEPAGE="http://www.gnu.org/software/coreutils/"
SRC_URI="ftp://alpha.gnu.org/gnu/coreutils/${P}.tar.bz2
	mirror://gnu/${PN}/${P}.tar.bz2
	mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/${P}-patches-${PATCH_VER}.tar.bz2
	http://dev.gentoo.org/~vapier/dist/${P}-patches-${PATCH_VER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="acl nls selinux static xattr"
RESTRICT="confcache"

RDEPEND="selinux? ( sys-libs/libselinux )
	acl? ( sys-apps/acl sys-apps/attr )
	nls? ( >=sys-devel/gettext-0.15 )
	userland_GNU? ( >=sys-apps/man-pages-2.46 )
	!net-mail/base64
	>=sys-libs/ncurses-5.3-r5"
DEPEND="${RDEPEND}
	=sys-devel/automake-1.9*
	>=sys-devel/autoconf-2.61
	>=sys-devel/m4-1.4-r1
	sys-apps/help2man"

pkg_setup() {
	# fixup expr for #123342
	if [[ $(/bin/expr a : '\(a\)') != "a" ]] ; then
		if [[ -x /bin/busybox ]] ; then
			ln -sf /bin/busybox /bin/expr
		else
			eerror "Your expr binary appears to be broken, please fix it."
			eerror "For more info, see http://bugs.gentoo.org/123342"
			die "your expr is broke"
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	PATCHDIR="${WORKDIR}/patch"
	rm -f "${PATCHDIR}"/generic/001_*progress*

	# Apply the ACL/SELINUX patches.
	if use selinux ; then
		EPATCH_MULTI_MSG="Applying SELINUX patches ..." \
		EPATCH_SUFFIX="patch" epatch "${PATCHDIR}"/selinux
	else
		EPATCH_MULTI_MSG="Applying ACL patches ..." \
		EPATCH_SUFFIX="patch" epatch "${PATCHDIR}"/acl
	fi

	EPATCH_SUFFIX="patch" epatch "${PATCHDIR}"/generic
	chmod a+rx tests/sort/sort-mb-tests

	# Since we've patched many .c files, the make process will
	# try to re-build the manpages by running `./bin --help`.
	# When cross-compiling, we can't do that since 'bin' isn't
	# a native binary, so let's just install outdated man-pages.
	tc-is-cross-compiler && touch man/*.1
	# There's no reason for this crap to use the private version
	sed -i 's:__mempcpy:mempcpy:g' lib/*.c

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	if ! type -p cvs > /dev/null ; then
		# Fix issues with gettext's autopoint if cvs is not installed,
		# bug #28920.
		export AUTOPOINT="/bin/true"
	fi

	local myconf=""
	[[ ${USERLAND} == "GNU" ]] || myconf="${myconf} --bindir=/usr/libexec/gnu"
	if echo "#include <regex.h>" | $(tc-getCPP) > /dev/null ; then
		myconf="${myconf} --without-included-regex"
	fi

	use static && append-ldflags -static
	econf \
		--enable-largefile \
		$(use_enable nls) \
		$(use_enable acl) \
		$(use_enable xattr) \
		$(use_enable selinux) \
		${myconf} \
		|| die "econf"
	emake || die "emake"
}

src_test() {
	# Non-root tests will fail if the full path isnt
	# accessible to non-root users
	chmod -R go-w "${WORKDIR}"
	chmod a+rx "${WORKDIR}"
	addwrite /dev/full
	export RUN_EXPENSIVE_TESTS="yes"
	#export FETISH_GROUPS="portage wheel"
	make check || die "make check failed"
}

src_install() {
	emake install DESTDIR="${D}" || die
	rm -f "${D}"/usr/lib/charset.alias
	dodoc AUTHORS ChangeLog* NEWS README* THANKS TODO

	# remove files provided by other packages
	rm "${D}"/usr/bin/{kill,uptime} # procps
	rm "${D}"/usr/bin/{groups,su}   # shadow
	rm "${D}"/usr/bin/hostname      # net-tools
	rm "${D}"/usr/share/man/man1/{groups,kill,hostname,su,uptime}.1

	insinto /etc
	newins src/dircolors.hin DIR_COLORS

	if [[ ${USERLAND} == "GNU" ]] ; then
		cd "${D}"/usr/bin
		dodir /bin
		# move critical binaries into /bin (required by FHS)
		local fhs="cat chgrp chmod chown cp date dd df echo false ln ls
		           mkdir mknod mv pwd rm rmdir stty sync true uname"
		mv ${fhs} ../../bin/ || die "could not move fhs bins"
		# move critical binaries into /bin (common scripts)
		local com="basename chroot cut dir dirname du env expr head mkfifo
		           readlink seq sleep sort tail touch tr tty vdir wc yes"
		mv ${com} ../../bin/ || die "could not move common bins"
		local x
		for x in ${com} ; do
			dosym /bin/${x} /usr/bin/${x} || die
		done
	else
		# For now, drop the man pages, collides with the ones of the system.
		rm -rf "${D}"/usr/share/man
	fi
}

pkg_postinst() {
	ewarn "Make sure you run 'hash -r' in your active shells."
}
