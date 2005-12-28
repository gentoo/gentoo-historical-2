# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/windowmaker/windowmaker-0.92.0-r1.ebuild,v 1.2 2005/12/28 22:31:26 halcy0n Exp $

inherit eutils gnustep-funcs flag-o-matic multilib

S=${WORKDIR}/${P/windowm/WindowM}

DESCRIPTION="The fast and light GNUstep window manager"
SRC_URI="ftp://ftp.windowmaker.org/pub/source/release/${P/windowm/WindowM}.tar.gz
	http://www.windowmaker.org/pub/source/release/WindowMaker-extra-0.1.tar.gz"
HOMEPAGE="http://www.windowmaker.org/"

IUSE="gif gnustep jpeg nls png tiff modelock xinerama"
DEPEND="x11-base/xorg-x11
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
KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~mips ~alpha"

if use gnustep; then
	egnustep_install_domain "Local"
fi

src_unpack() {
	is-flag -fstack-protector && filter-flags -fstack-protector \
		&& ewarn "CFLAG -fstack-protector has been disabled, as it is known to cause bugs with WindowMaker (bug #78051)" && ebeep 2
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV/0.92/0.91}/singleclick-shadeormaxopts-0.9x.patch2 || die "single click and shade-or-maximize-options patch failed"
	epatch "${FILESDIR}"/${PV/0.92/0.91}/wlist-0.9x.patch || die "window list patch failed"
#	epatch ${FILESDIR}/${PV}/64bit+endian-fixes-0.9x.patch || die "64-bit + endian fix patch failed"
	epatch "${FILESDIR}"/${PV}/${P}-gcc41.patch
}

src_compile() {
	local myconf
	local gs_user_postfix

	# image format types
	# xpm is provided by X itself
	myconf="--enable-xpm $(use_enable png) $(use_enable jpeg) $(use_enable gif) $(use_enable tiff)"

	# non required X capabilities
	myconf="${myconf} $(use_enable modelock) $(use_enable xinerama)"

	# integrate with GNUstep environment, or not
	if use gnustep ; then
		# install WPrefs.app into GS Local Domain after setting up the GS env
		egnustep_env
#		myconf="${myconf} --with-gnustepdir=$(egnustep_system_root)/Applications"
	else
		# no change from wm-0.80* ebuilds, as to not pollute things more
		myconf="${myconf} --with-gnustepdir=/usr/$(get_libdir)/GNUstep"
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
		${myconf} || die

#	# call here needed as some users report breakage with one of the above
#	#  patches (though patched after autoreconf)
#	libtoolize --copy --force

#	# don't know if zh_TW is still non-functional, but leaving it out still
#	#  for now
#	cd ${S}/po
#	cp Makefile Makefile.orig
#	sed 's:zh_TW.*::' \
#		Makefile.orig > Makefile

#	cd ${S}/WPrefs.app/po
#	cp Makefile Makefile.orig
#	sed 's:zh_TW.*::' \
#		Makefile.orig > Makefile

	cd ${S}
	for file in ${S}/WindowMaker/*menu*; do
		if [ -r $file ]; then
			if use gnustep ; then
#				sed -e "s/\/usr\/local\/GNUstep/`cat ${TMP}/sed.gs_prefix`System/g;
#					s/XXX_SED_FSLASH/\//g;" < $file > $file.tmp
				sed -e "s:/usr/local/GNUstep:`cat ${TMP}/sed.gs_prefix`System:g;" \
					-e "s:XXX_SED_FSLASH:/:g;" < $file > $file.tmp
			else
#				sed -e 's/\/usr\/local\/GNUstep/\/usr\/lib\/GNUstep/g;' < $file > $file.tmp
				sed -e "s:/usr/local/GNUstep:/usr/$(get_libdir)/GNUstep:g;" < $file > $file.tmp
			fi
			mv $file.tmp $file;

#			sed -e 's/\/usr\/local\/share\/WindowMaker/\/usr\/share\/WindowMaker/g;' < $file > $file.tmp;
			sed -e 's:/usr/local/share/WindowMaker:/usr/share/WindowMaker:g;' < $file > $file.tmp;
			mv $file.tmp $file;
		fi;
	done;

	# amd64 and mmx don't play nice together (yet)
	use amd64 && sed -i -e '/ASM_X86/ d' "${S}/src/config.h"

	cd ${S}
	emake -j1 || die "windowmaker: make has failed"

	cd ${S}
	for file in ${S}/WindowMaker/Defaults/W*; do
		if [ -r $file ]; then
			if use gnustep; then
				sed -e "s/\$HOME\/GNUstep\//\$HOME`cat ${TMP}/sed.gs_user_root_suffix`/g;
						s/XXX_SED_FSLASH/\//g;" < $file > $file.tmp
				mv $file.tmp $file;

				sed -e "s/~\/GNUstep\//~`cat ${TMP}/sed.gs_user_root_suffix`/g;
						s/XXX_SED_FSLASH/\//g;" < $file > $file.tmp
				mv $file.tmp $file;
			fi
		fi
	done;

	# WindowMaker Extra Package (themes and icons)
	cd ../WindowMaker-extra-0.1
	econf || die "windowmaker-extra: configure has failed"
	emake || die "windowmaker-extra: make has failed"
}

src_install() {
	emake install DESTDIR=${D} || die "windowmaker: install has failed."

	dodoc AUTHORS BUGFORM BUGS ChangeLog COPYING* INSTALL* FAQ* \
	      MIRRORS README* NEWS TODO

	# WindowMaker Extra
	cd ../WindowMaker-extra-0.1
	emake install DESTDIR=${D} || die "windowmaker-extra: install failed"

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

pkg_postinst() {
	if use gnustep ; then
		einfo "WPrefs.app is installed in you GNUstep Local Domain Applications directory."
	fi
}

