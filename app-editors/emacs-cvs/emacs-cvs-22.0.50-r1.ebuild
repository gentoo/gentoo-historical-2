# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/emacs-cvs/emacs-cvs-22.0.50-r1.ebuild,v 1.1 2006/02/09 01:38:23 mkennedy Exp $

ECVS_AUTH="pserver"
ECVS_SERVER="cvs.savannah.gnu.org:/sources/emacs"
ECVS_MODULE="emacs"
ECVS_BRANCH="HEAD"

inherit elisp-common cvs alternatives flag-o-matic eutils

IUSE="X Xaw3d aqua gif gtk jpeg nls png spell tiff"
# IUSE="X Xaw3d aqua gif gtk jpeg nls png spell tiff xft"

S=${WORKDIR}/emacs

DESCRIPTION="Emacs is the extensible, customizable, self-documenting real-time display editor."
SRC_URI=""
HOMEPAGE="http://www.gnu.org/software/emacs"

# Never use the sandbox, it causes Emacs to segfault on startup
SANDBOX_DISABLED="1"
RESTRICT="$RESTRICT nostrip"

X_DEPEND="x11-libs/libXmu x11-libs/libXpm x11-libs/libXt x11-misc/xbitmaps || ( media-fonts/font-adobe-100dpi media-fonts/font-adobe-75dpi )"

DEPEND=">=sys-libs/ncurses-5.3
	spell? ( || ( app-text/ispell app-text/aspell ) )
	X? ( || ( ( $X_DEPEND ) virtual/x11 ) )
	X? ( gif? ( >=media-libs/giflib-4.1.0.1b )
		jpeg? ( >=media-libs/jpeg-6b )
		tiff? ( >=media-libs/tiff-3.5.7 )
		png? ( >=media-libs/libpng-1.2.5 )
		gtk? ( =x11-libs/gtk+-2* )
		!gtk? ( Xaw3d? ( x11-libs/Xaw3d ) ) )
	nls? ( >=sys-devel/gettext-0.11.5 )
	sys-libs/zlib
	>=sys-apps/portage-2.0.51_rc1"

PROVIDE="virtual/emacs virtual/editor"

SLOT="22.0.50"
LICENSE="GPL-2"
# KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~ppc-macos"
KEYWORDS="-*"					# until XFT support is finalized

DFILE=emacs-${SLOT}.desktop

# pkg_setup() {
#	if use xft; then
#		while read line; do ewarn "${line}"; done <<EOF

# You have chosen to build Emacs using the XFT_JHD_BRANCH.	The
# XFT_JHD_BRANCH is very early work towards supporting XFT in Emacs.
# Emerging app-editors/emacs-cvs was risky enough, trying out the
# XFT_JHD_BRANCH branch for XFT support even more so!

# EOF
#		ebeep
#	fi
# }

src_unpack() {
#	if use xft; then
#		ECVS_BRANCH=XFT_JHD_BRANCH
#	else
		ECVS_BRANCH=HEAD
#	fi
	cvs_src_unpack
	cd ${S};
	epatch ${FILESDIR}/emacs-subdirs-el-gentoo.diff
	use ppc-macos && epatch ${FILESDIR}/emacs-cvs-21.3.50-nofink.diff
#	if use xft; then
#		epatch ${FILESDIR}/xft-invertcursor.patch
#		epatch ${FILESDIR}/xft-bgalpha.patch
#		epatch ${FILESDIR}/xft-xfaces-fixcrash.patch
#	fi
}

src_compile() {
	# no flag is allowed
	ALLOWED_FLAGS=" "
	strip-flags
	unset LDFLAGS

	sed -i -e "s/-lungif/-lgif/g" configure* src/Makefile* || die

	local myconf

	use nls || myconf="${myconf} --disable-nls"

	if use X; then
		myconf="${myconf} --with-x"
		myconf="${myconf} --with-xpm --with-toolkit-scroll-bars"
		myconf="${myconf} $(use_with jpeg) $(use_with tiff)"
		myconf="${myconf} $(use_with gif) $(use_with png)"
		if use gtk; then
			einfo "Configuring to build with GTK support"
			myconf="${myconf} --with-x-toolkit=gtk"
		elif use Xaw3d; then
			einfo "Configuring to build with Xaw3d support"
			myconf="${myconf} --with-x-toolkit=athena"
		else
			einfo "Configuring to build with lucid toolkit support"
			myconf="${myconf} --without-gtk"
			myconf="${myconf} --with-x-toolkit=lucid"
		fi
#		if use xft; then
#			# this is only relevant when the source is patched for XFT
#			# support, so it must remain within this if/then block
#			myconf="${myconf} $(use_with xft)"
#		fi
	else
		myconf="${myconf} --without-x"
	fi

	if use aqua ; then
		einfo "Configuring to build with Carbon Emacs"
		econf --enable-debug \
			--enable-carbon-app=/Applications/Gentoo \
			--without-x \
			$(use_with jpeg) $(use_with tiff) \
			$(use_with gif) $(use_with png) \
			 || die "econf carbon emacs failed"
		make bootstrap || die "make carbon emacs bootstrap failed"
	fi

	econf --enable-debug \
		--program-suffix=.emacs-${SLOT} \
		--without-carbon \
		${myconf} || die "econf emacs failed"

	make bootstrap || die "make emacs bootstrap failed"
}

src_install () {
	# make DESTDIR=${D} install doesn't work
	einstall || die "einstall failed"
	rm ${D}/usr/bin/emacs-${SLOT}.emacs-${SLOT} || die "removing duplicate emacs executable failed"
	dohard /usr/bin/emacs.emacs-${SLOT} /usr/bin/emacs-${SLOT} || die

	if use aqua ; then
		einfo "Installing Carbon Emacs..."
		dodir /Applications/Gentoo/Emacs.app
		pushd mac/Emacs.app
		tar -chf - . | ( cd ${D}/Applications/Gentoo/Emacs.app; tar -xf -)
		popd
	fi

	# fix info documentation
	einfo "Fixing info documentation..."
	dodir /usr/share/info/emacs-${SLOT}
	mv ${D}/usr/share/info/{,emacs-${SLOT}/}dir || die "mv dir failed"
	for i in ${D}/usr/share/info/*
	do
		if [ "${i##*/}" != emacs-${SLOT} ] ; then
			mv ${i} ${i/info/info/emacs-${SLOT}}.info
			gzip -9 ${i/info/info/emacs-${SLOT}}.info
		fi
	done

	if has_version 'app-text/aspell' ; then
		# defaults to aspell if installed
		elisp-site-file-install ${FILESDIR}/40aspell-gentoo.el
	fi
	newenvd ${FILESDIR}/50emacs-${SLOT}.envd 50emacs-${SLOT}

	einfo "Fixing manpages..."
	for m in  ${D}/usr/share/man/man1/* ; do
		mv ${m} ${m/.1/.emacs-${SLOT}.1} || die "mv man failed"
	done

	dodoc BUGS ChangeLog README

	insinto /usr/share/applications
	doins ${FILESDIR}/${DFILE}
}

update-alternatives() {
	for i in emacs emacsclient etags ctags b2m ebrowse \
		rcs-checkin grep-changelog ; do
		alternatives_auto_makesym "/usr/bin/$i" "/usr/bin/$i.emacs-*"
	done
}

pkg_postinst() {
	use ppc-macos || update-alternatives
}

pkg_postrm() {
	use ppc-macos || update-alternatives
}
