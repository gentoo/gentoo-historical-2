# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fxload/fxload-20020411.ebuild,v 1.13 2004/06/24 22:07:13 agriffis Exp $

# source maintainers named it fxload-YYYY_MM_DD instead of fxload-YYYYMMDD
MY_P=`echo $P|sed 's/-\(....\)\(..\)\(..\)/-\1_\2_\3/'`
S=${WORKDIR}/${MY_P}
DESCRIPTION="USB firmware uploader"
SRC_URI="http://unc.dl.sourceforge.net/sourceforge/linux-hotplug/fxload-2002_04_11.tar.gz"
HOMEPAGE="http://linux-hotplug.sourceforge.net"
KEYWORDS="x86 amd64 ppc sparc ~hppa"
SLOT="0"
LICENSE="GPL-2"

# fxload needs pcimodules utility provided by pcitutils-2.1.9-r1
DEPEND="virtual/glibc
	sys-apps/hotplug"

src_compile() {
	# compile fxload program
	make || die
}

src_install() {
	make install prefix=${D}
}
