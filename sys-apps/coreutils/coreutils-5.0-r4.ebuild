# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/coreutils/coreutils-5.0-r4.ebuild,v 1.13 2003/11/03 05:47:12 pebenito Exp $

inherit eutils

IUSE="nls build acl static"

PATCH_VER=1.7

S="${WORKDIR}/${P}"
DESCRIPTION="Standard GNU file utilities (chmod, cp, dd, dir, ls...), text utilities (sort, tr, head, wc..), and shell utilities (whoami, who,...)"
HOMEPAGE="http://www.gnu.org/software/coreutils/"
SRC_URI="http://ftp.gnu.org/pub/gnu/coreutils/${P}.tar.bz2
	mirror://gentoo/${PN}-gentoo-${PATCH_VER}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ppc ~sparc alpha hppa ~arm ~mips ia64"

DEPEND="virtual/glibc
	>=sys-apps/portage-2.0.49
	sys-devel/automake
	sys-devel/autoconf
	nls? ( sys-devel/gettext )
	acl? ( sys-apps/acl )"

PATCHDIR=${WORKDIR}/patch

src_unpack() {
	unpack ${A}
	cd ${S}

	# HPPA and ARM platforms do not work well with the uname patch
	# (see below about it)
	if use hppa || use arm
	then
		mv ${PATCHDIR}/004* ${PATCHDIR}/excluded
	fi

	# Apply the ACL patches. 
	# WARNING: These CONFLICT with the SELINUX patches
	if use acl
	then
		if [ -z "`use nls`" ] ; then
			mv ${PATCHDIR}/acl/004* ${PATCHDIR}/excluded
		fi
		mv ${PATCHDIR}/001* ${PATCHDIR}/excluded
		EPATCH_SUFFIX="patch" epatch ${PATCHDIR}/acl
	fi

	# patch to remove Stallman's su/wheel group rant (which doesn't apply,
	# since Gentoo's su is not GNU/su, but that from shadow.
	# do not include su infopage, as it is not valid for the su
	# from sys-apps/shadow that we are using.
	# Patch to add processor specific info to the uname output

	EPATCH_SUFFIX="patch" epatch ${PATCHDIR}
}

src_compile() {
	local myconf=
	use nls || myconf="--disable-nls"

	if use acl
	then
		if [ -z "`which cvs 2>/dev/null`" ]
		then
			# Fix issues with gettext's autopoint if cvs is not installed,
			# bug #28920.
			export AUTOPOINT="/bin/true"
		fi
		mv m4/inttypes.m4 m4/inttypes-eggert.m4
		autoreconf --force --install || die
	fi

	econf \
		--bindir=/bin \
		${myconf} || die

	if use static
	then
		emake LDFLAGS=-static || die
	else
		emake || die
	fi
}

src_install() {
	einstall \
		bindir=${D}/bin || die

	# hostname comes from net-base
	# hostname does not work with the -f switch, which breaks gnome2
	#   amongst other things
	rm -f ${D}/{bin,usr/bin}/hostname ${D}/usr/share/man/man1/hostname.*

	# /bin/su comes from sys-apps/shadow
	rm -f ${D}/{bin,usr/bin}/su ${D}/usr/share/man/man1/su.*

	# /usr/bin/uptime comes from the sys-apps/procps packaga
	rm -f ${D}/{bin,usr/bin}/uptime ${D}/usr/share/man/man1/uptime*

	cd ${D}
	dodir /usr/bin
	rm -rf usr/lib
	cd usr/bin
	ln -s ../../bin/* .

	if [ -z "`use build`" ]
	then
		cd ${S}
		dodoc AUTHORS ChangeLog* COPYING NEWS README* THANKS TODO
	else
		rm -rf ${D}/usr/share
	fi
}

pkg_postinst() {
	# hostname does not get removed as it is included with older stage1
	# tarballs, and net-tools installs to /bin
	if [ -e ${ROOT}/usr/bin/hostname ] && [ ! -L ${ROOT}/usr/bin/hostname ]
	then
		rm -f ${ROOT}/usr/bin/hostname
	fi
}
