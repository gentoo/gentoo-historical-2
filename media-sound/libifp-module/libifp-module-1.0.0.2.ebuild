# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/libifp-module/libifp-module-1.0.0.2.ebuild,v 1.4 2006/02/27 20:53:34 chutzpah Exp $

inherit linux-mod

DESCRIPTION="Linux Kernel module to allow libifp access as a non-root user."
HOMEPAGE="http://ifp-driver.sourceforge.net/libifp/"
SRC_URI="mirror://sourceforge/ifp-driver/libifp-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="virtual/linux-sources"

S="${WORKDIR}/libifp-${PV}"

MODULE_NAMES="libifp(misc:${S}:${S}/kbuild)"
BUILD_TARGETS="all"
ECONF_PARAMS="--with-kmodule --without-libifp"
