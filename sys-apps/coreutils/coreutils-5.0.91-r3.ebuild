# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/coreutils/coreutils-5.0.91-r3.ebuild,v 1.15 2004/06/28 18:32:47 vapier Exp $

inherit eutils flag-o-matic

PATCH_VER=1.4.4
I18N_PATCH=i18n-0.2
PATCHDIR=${WORKDIR}/patch

DESCRIPTION="Standard GNU file utilities (chmod, cp, dd, dir, ls...), text utilities (sort, tr, head, wc..), and shell utilities (whoami, who,...)"
HOMEPAGE="http://www.gnu.org/software/coreutils/"
SRC_URI="mirror://gnu/coreutils/${P}.tar.bz2
	mirror://coreutils/${P}.tar.bz2
	http://www.openi18n.org/subgroups/utildev/patch/${P}-${I18N_PATCH}.patch.gz
	mirror://gentoo/${P}-gentoo-${PATCH_VER}.tar.bz2
	mirror://gentoo/${P}-gentoo-${PATCH_VER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~hppa ~amd64 ~ia64 ~ppc64"
IUSE="nls build acl selinux static"

RDEPEND="selinux? ( sys-libs/libselinux )
	acl? ( !hppa? ( sys-apps/acl sys-apps/attr ) )
	nls? ( sys-devel/gettext )
	>=sys-libs/libtermcap-compat-2.0.8"
DEPEND="${RDEPEND}
	virtual/libc
	>=sys-apps/portage-2.0.49
	>=sys-devel/automake-1.7.6
	>=sys-devel/autoconf-2.57
	>=sys-devel/m4-1.4-r1
	sys-apps/help2man"

src_unpack() {
	unpack ${A}

	cd ${S}

	if use acl && use selinux
	then
		ewarn "Both ACL and SELINUX are not supported together!"
		ewarn "Will Select SELINUX instead"
	fi

	# Mandrake's lsw patch caused issues on ia64 and amd64 with ls
	# Reported upstream, but we don't apply it for now
	mv ${PATCHDIR}/mandrake/019* ${PATCHDIR}/excluded

	EPATCH_SUFFIX="patch" epatch ${PATCHDIR}/mandrake
	epatch ${WORKDIR}/${P}-${I18N_PATCH}.patch

	# ARM platform does not work well with the uname patch
	# (see below about it)
	if use arm
	then
		mv ${PATCHDIR}/003* ${PATCHDIR}/excluded
	fi

	# Apply the ACL patches. 
	# WARNING: These CONFLICT with the SELINUX patches
	if use acl
	then
	#
	# This one also needs porting like the rest, but its a bit more involved,
	# so I will leave it for somebody that use i18n that can actually test it.
	#
	#	if ! use nls ; then
			mv ${PATCHDIR}/acl/004* ${PATCHDIR}/excluded
	#	fi

		# This test do seem to be fixed in another way, the acl guys
		# can just verify please ...
		mv ${PATCHDIR}/acl/006* ${PATCHDIR}/excluded

		use selinux || mv ${PATCHDIR}/{001*,002*,004*} ${PATCHDIR}/excluded
		use selinux || EPATCH_SUFFIX="patch" epatch ${PATCHDIR}/acl
	fi

	# patch to remove Stallman's su/wheel group rant (which doesn't apply,
	# since Gentoo's su is not GNU/su, but that from shadow.
	# do not include su infopage, as it is not valid for the su
	# from sys-apps/shadow that we are using.
	# Patch to add processor specific info to the uname output

	EPATCH_SUFFIX="patch" epatch ${PATCHDIR}

	use selinux && EPATCH_SUFFIX="patch" epatch ${PATCHDIR}/selinux
}

src_compile() {
	local myconf=
	use nls || myconf="--disable-nls"

	if use acl
	then
		if ! use selinux
		then
			if [ -z "`which cvs 2>/dev/null`" ]
			then
				# Fix issues with gettext's autopoint if cvs is not installed,
				# bug #28920.
				export AUTOPOINT="/bin/true"
			fi
			mv m4/inttypes.m4 m4/inttypes-eggert.m4
		fi
	fi

	export WANT_AUTOMAKE=1.7

	aclocal -I ${S}/m4 || die
	autoconf || die
	automake || die

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

	cd ${D}
	dodir /usr/bin
	rm -rf usr/lib
	cd usr/bin
	ln -s ../../bin/* .

	if ! use build
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
