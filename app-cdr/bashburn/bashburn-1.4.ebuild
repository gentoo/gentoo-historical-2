# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/bashburn/bashburn-1.4.ebuild,v 1.6 2004/09/30 20:41:55 slarti Exp $


MY_P=${P//b/B}
DESCRIPTION="cd burning shell script"
HOMEPAGE="http://bashburn.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ~amd64"
IUSE=""

DEPEND="virtual/libc
	>=app-cdr/cdrtools-2.01_alpha25
	>=app-cdr/cdrdao-1.1.7
	virtual/mpg123
	media-sound/lame
	media-sound/vorbis-tools
	media-sound/normalize
	media-libs/flac
	sys-apps/eject"

RDEPEND="app-shells/bash"

src_compile() {
	echo "Skipping Compile"
}

src_install() {
	sed -i "s:export CONFFILE=/etc/bashburnrc:export CONFFILE=/etc/bashburn/bashburnrc:g" BashBurn.sh
	sed -i "s:ROOTDIR\:.*:ROOTDIR\: /opt/BashBurn:g" bashburnrc

	dodir /etc/bashburn
	dodir /opt/BashBurn
	dodir /usr/bin

	mv {burning,config,convert,menus,misc} ${D}/opt/BashBurn

	exeinto /opt/BashBurn
	doexe BashBurn.sh || die
	cp bashburnrc ${D}/etc/bashburn
	ln -sf /opt/BashBurn/BashBurn.sh ${D}/usr/bin/bashburn

	dodoc README HOWTO
}
