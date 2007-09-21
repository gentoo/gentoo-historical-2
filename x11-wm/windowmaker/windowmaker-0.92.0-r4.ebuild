# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/windowmaker/windowmaker-0.92.0-r4.ebuild,v 1.3 2007/09/21 14:15:06 voyageur Exp $

inherit autotools eutils gnustep-base flag-o-matic

S=${WORKDIR}/${P/windowm/WindowM}

DESCRIPTION="The fast and light GNUstep window manager"
SRC_URI="ftp://ftp.windowmaker.info/pub/source/release/${P/windowm/WindowM}.tar.gz
	http://www.windowmaker.info/pub/source/release/WindowMaker-extra-0.1.tar.gz"
HOMEPAGE="http://www.windowmaker.info/"

IUSE="gif gnustep jpeg nls png tiff modelock xinerama"
DEPEND="x11-libs/libXv
	x11-libs/libXft
	x11-libs/libXt
	media-libs/fontconfig
	gif? ( >=media-libs/giflib-4.1.0-r3 )
	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( >=media-libs/jpeg-6b-r2 )
	tiff? ( >=media-libs/tiff-3.6.1-r2 )
	gnustep? ( gnustep-base/gnustep-make )"
RDEPEND="${DEPEND}
	nls? ( >=sys-devel/gettext-0.10.39 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

src_unpack() {
	is-flag -fstack-protector && filter-flags -fstack-protector \
		&& ewarn "CFLAG -fstack-protector has been disabled, as it is known to cause bugs with WindowMaker (bug #78051)" && ebeep 2
	replace-flags "-Os" "-O2"
	replace-flags "-O3" "-O2"

	unpack ${A}
	cd "${S}"
	epatch ${FILESDIR}/${PV/0.92/0.91}/singleclick-shadeormaxopts-0.9x.patch2
	epatch ${FILESDIR}/${PV/0.92/0.91}/wlist-0.9x.patch
	epatch ${FILESDIR}/${PV}/${P}-configure.patch
	epatch ${FILESDIR}/${PV}/${P}-gcc41.patch
	epatch ${FILESDIR}/${PV}/${P}-fullscreen.patch
	epatch ${FILESDIR}/${PV}/${P}-qtdialogsfix.patch

	# Fix some paths
	if use gnustep; then
		egnustep_env
	fi
	for file in ${S}/WindowMaker/*menu*; do
		if [ -r $file ]; then
			if use gnustep ; then
				sed -i "s:/usr/local/GNUstep/Applications:${GNUSTEP_SYSTEM_APPS}:g" $file
			else
				sed -i "s:/usr/local/GNUstep/Applications/WPrefs.app:/usr/bin/:g;" $file
			fi

			sed -i 's:/usr/local/share/WindowMaker:/usr/share/WindowMaker:g;' $file
			sed -i 's:/opt/share/WindowMaker:/usr/share/WindowMaker:g;' $file
		fi;
	done;

	eautoreconf || die "eautoreconf failed"
}

src_compile() {
	local myconf

	# image format types
	# xpm is provided by X itself
	myconf="--enable-xpm $(use_enable png) $(use_enable jpeg) $(use_enable gif) $(use_enable tiff)"

	# non required X capabilities
	myconf="${myconf} $(use_enable modelock) $(use_enable xinerama)"

	if use gnustep ; then
		egnustep_env
		myconf="${myconf} --with-gnustepdir=${GNUSTEP_SYSTEM_ROOT}"
	fi

	if use nls; then
		[ -z "$LINGUAS" ] && export LINGUAS="`ls po/*.po | sed 's:po/\(.*\)\.po$:\1:'`"
	else
		myconf="${myconf} --disable-locale"
	fi

	# default settings with $myconf appended
	econf \
		--sysconfdir=/etc/X11 \
		--with-x \
		--enable-usermenu \
		--with-pixmapdir=/usr/share/pixmaps \
		--with-nlsdir=/usr/share/locale \
		${myconf} || die

	emake || die "windowmaker: make has failed"

	# WindowMaker Extra Package (themes and icons)
	cd ../WindowMaker-extra-0.1
	econf || die "windowmaker-extra: configure has failed"
	emake || die "windowmaker-extra: make has failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "windowmaker: install has failed."

	dodoc AUTHORS BUGFORM BUGS ChangeLog COPYING* INSTALL* FAQ* \
		  MIRRORS README* NEWS TODO

	# WindowMaker Extra
	cd ../WindowMaker-extra-0.1
	emake DESTDIR="${D}" install || die "windowmaker-extra: install failed"

	newdoc README README.extra

	# create wmaker session shell script
	echo "#!/bin/bash" > wmaker
	echo "/usr/bin/wmaker" >> wmaker
	exeinto /etc/X11/Sessions/
	doexe wmaker

	insinto /etc/X11/dm/Sessions
	doins ${FILESDIR}/wmaker.desktop
	make_desktop_entry /usr/bin/wmaker
}
