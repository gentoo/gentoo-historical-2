# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/mythfrontend/mythfrontend-0.10.ebuild,v 1.4 2003/09/08 07:08:41 msterret Exp $

inherit flag-o-matic

IUSE="lcd"
DESCRIPTION="Homebrew PVR project frontend."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://www.mythtv.org/mc/mythtv-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/x11
	>=x11-libs/qt-3
	>=media-sound/lame-3.92
	>=media-libs/freetype-2.0
	>=sys-apps/sed-4
	lcd? ( app-misc/lcdproc )"

RDEPEND="${DEPEND}
	!media-tv/mythtv"

S="${WORKDIR}/mythtv-${PV}"

src_unpack() {
	unpack ${A}

	for i in `grep -lr usr/local "${S}"` ; do
		sed -e "s:usr/local:usr:" -i "${i}" || die "sed failed"
	done
}

src_compile() {
	cpu="`get-flag march`"
	if [ -n "${cpu}" ] ; then
		sed -e "s:pentiumpro:${cpu}:g" -i "${S}/settings.pro" || die "sed failed"
	fi

	qmake -o "${S}/Makefile" "${S}/mythtv.pro"

	econf `use_enable lcd`

	# Parallel build doesn't work.
	make || die "compile problem"
}

src_install() {
	make INSTALL_ROOT="${D}" install || die "make install failed"

	dodir /etc/mythtv
	mv "${D}/usr/share/mythtv/mysql.txt" "${D}/etc/mythtv"
	dosym /etc/mythtv/mysql.txt /usr/share/mythtv/mysql.txt

	rm -rf "${D}"/usr/bin/myth{backend,commflag,filldatabase,transcode} \
		"${D}/usr/share/mythtv/setup.xml"

	dodoc AUTHORS COPYING FAQ README UPGRADING keys.txt docs/*.txt
	dohtml docs/*.html
}
