# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2 
# $Header: /var/cvsroot/gentoo-x86/media-tv/mythtv/mythtv-0.10.ebuild,v 1.1 2003/07/09 00:05:43 johnm Exp $

inherit flag-o-matic

IUSE="lcd mmx oss"
DESCRIPTION="Homebrew PVR project."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://www.mythtv.org/mc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=x11-libs/qt-3
	media-libs/a52dec
	>=media-tv/xmltv-0.5.14
	media-sound/lame
	>=media-libs/freetype-2.0
	>=sys-apps/sed-4
	virtual/x11"

RDEPEND="${DEPEND}
	lcd? ( app-misc/lcdproc )"

src_unpack() {

	unpack ${A}

	for i in `grep -lr usr/local "${S}"` ; do
		sed -e "s:usr/local:usr:" -i "${i}" || die "sed failed"
	done

}

src_compile() {

	local myconf="--enable-a52bin --enable-shared"
	myconf="${myconf} `use_enable lcd`"
	myconf="${myconf} `use_enable mmx`"
	myconf="${myconf} `use_enable oss audio-oss`"

	cpu="`get-flag march`"
	if [ -n "${cpu}" ] ; then
		myconf="${myconf} --cpu=${cpu}"
		sed -e "s:pentiumpro:${cpu}:g" -i "${S}/settings.pro" || die "sed failed"
	fi

	qmake -o "${S}/Makefile" "${S}/${PN}.pro"

	econf ${myconf}

	# Parallel build doesn't work.
	make || die "compile problem"

}

src_install() {

	make INSTALL_ROOT="${D}" install || die "make install failed"
	newbin "setup/setup" "mythsetup"

	dodir /etc/mythtv
	mv "${D}/usr/share/mythtv/mysql.txt" "${D}/etc/mythtv"
	dosym /etc/mythtv/mysql.txt /usr/share/mythtv/mysql.txt

	exeinto /etc/init.d
	newexe "${FILESDIR}/mythbackend.rc6" mythbackend

	insinto /etc/conf.d
	newins "${FILESDIR}/mythbackend.conf" mythbackend

	exeinto /usr/share/mythtv
	doexe "${FILESDIR}/mythfilldatabase.cron"

	insinto /usr/share/mythtv/database
	doins "${S}"/database/*

	dodoc AUTHORS COPYING FAQ README UPGRADING keys.txt docs/*.txt
	dohtml docs/*.html

	keepdir /var/{log,run}/mythtv

}

pkg_postinst() {

	ewarn "Please note that /usr/share/mythtv/setup has been moved"
	ewarn "to /usr/bin/mythsetup"
	echo

	einfo "If this is the first time you install MythTV,"
	einfo "you need to add /usr/share/mythtv/database/mc.sql"
	einfo "to your mysql database."
	einfo
	einfo "You might run 'mysql < /usr/share/mythtv/database/mc.sql'"
	einfo
	einfo "Next, you need to run the mythsetup program."
	einfo "It will ask you some questions about your hardware, and"
	einfo "then run xmltv's grabber to configure your channels."
	einfo
	einfo "Once you have configured your database, you can run"
	einfo "/usr/bin/mythfilldatabase to populate the schedule"
	einfo "or copy /usr/share/mythtv/mythfilldatabase.cron to"
	einfo "/etc/cron.daily for this to happen automatically."
	einfo
	einfo "If you're upgrading from an older version and for more"
	einfo "setup and usage instructions, please refer to:"
	einfo "   /usr/share/doc/${PF}/README.gz"
	einfo "   /usr/share/doc/${PF}/UPGRADING.gz"
	ewarn "This part is important as there might be database changes"
	ewarn "which need to be performed or this package will not work"
	ewarn "properly."
	echo

}
