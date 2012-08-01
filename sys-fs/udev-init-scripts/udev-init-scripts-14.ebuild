# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/udev-init-scripts/udev-init-scripts-14.ebuild,v 1.1 2012/08/01 17:15:24 williamh Exp $

EAPI=4

EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/udev-gentoo-scripts.git"

if [ "${PV}" = "9999" ]; then
	inherit git-2
fi

DESCRIPTION="udev startup scripts for openrc"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

if [ "${PV}" != "9999" ]; then
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DEPEND=""
RDEPEND=">=sys-fs/udev-187
	sys-apps/openrc
	!<sys-fs/udev-186"

src_compile()
{
	return 0
}

pkg_postinst()
{
	# If we are building stages, add udev to the sysinit runlevel automatically.
	if use build
	then
		if [[ -x "${ROOT}"/etc/init.d/udev \
			&& -d "${ROOT}"/etc/runlevels/sysinit ]]
		then
			ln -s /etc/init.d/udev "${ROOT}"/etc/runlevels/sysinit/udev
		fi
	fi

	# migration to >=openrc-0.4
	if [[ -e "${ROOT}"/etc/runlevels/sysinit \
		&& ! -e "${ROOT}"/etc/runlevels/sysinit/udev ]]
	then
		ewarn
		ewarn "You need to add the udev init script to the runlevel sysinit,"
		ewarn "otherwise your system will not be able to boot"
		ewarn "after updating to >=openrc-0.4.0"
		ewarn "Run this to enable udev for >=openrc-0.4.0:"
		ewarn "\trc-update add udev sysinit"
		ewarn
	fi

	ewarn "The udev-postmount service has been removed because the reasons for"
	ewarn "its existance have been removed upstream."
	ewarn "Please remove it from your runlevels."
}
