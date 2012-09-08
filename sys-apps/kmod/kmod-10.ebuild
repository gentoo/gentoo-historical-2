# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/kmod/kmod-10.ebuild,v 1.1 2012/09/08 17:35:44 ssuominen Exp $

EAPI=4

EGIT_REPO_URI="git://git.kernel.org/pub/scm/utils/kernel/${PN}/${PN}.git"

[[ ${PV} == 9999 ]] && vcs=git-2
inherit ${vcs} autotools eutils toolchain-funcs libtool
unset vcs

if [[ ${PV} != 9999 ]] ; then
	SRC_URI="mirror://kernel/linux/utils/kernel/kmod/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="library and tools for managing linux kernel modules"
HOMEPAGE="http://git.kernel.org/?p=utils/kernel/kmod/kmod.git"

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug doc lzma static-libs +tools zlib"

# Upstream does not support running the test suite with custom configure flags.
# I was also told that the test suite is intended for kmod developers.
# So we have to restrict it.
# See bug #408915.
RESTRICT="test"

RDEPEND="!sys-apps/module-init-tools
	!sys-apps/modutils
	lzma? ( app-arch/xz-utils )
	zlib? ( >=sys-libs/zlib-1.2.6 )" #427130
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	lzma? ( virtual/pkgconfig )
	zlib? ( virtual/pkgconfig )"

src_prepare()
{
	if [ ! -e configure ]; then
		if use doc; then
			gtkdocize --copy --docdir libkmod/docs || die
		else
			touch libkmod/docs/gtk-doc.make
		fi
		eautoreconf
	else
		elibtoolize
	fi
}

src_configure()
{
	econf \
		$(use_enable static-libs static) \
		$(use_enable tools) \
		$(use_enable debug) \
		$(use_enable doc gtk-doc) \
		$(use_with lzma xz) \
		$(use_with zlib)
}

src_install()
{
	default
	prune_libtool_files

	if use tools; then
		local cmd
		for cmd in depmod insmod lsmod modinfo modprobe rmmod; do
			dosym kmod /usr/bin/${cmd}
		done
		# Compability symlink(s):
		# These are both hardcoded in the Linux kernel source tree wrt #426698
		dosym /usr/bin/kmod /sbin/depmod
		dosym /usr/bin/kmod /sbin/modprobe
	fi
}
