# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/emacs-cvs/emacs-cvs-23.0.60-r2.ebuild,v 1.6 2008/02/06 12:39:27 ulm Exp $

ECVS_AUTH="pserver"
ECVS_SERVER="cvs.savannah.gnu.org:/sources/emacs"
ECVS_MODULE="emacs"
ECVS_BRANCH="HEAD"
ECVS_LOCALNAME="emacs"

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit autotools cvs elisp-common eutils flag-o-matic

DESCRIPTION="The extensible, customizable, self-documenting real-time display editor"
HOMEPAGE="http://www.gnu.org/software/emacs/"
SRC_URI=""

LICENSE="GPL-3 FDL-1.2 BSD"
SLOT="23"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"

IUSE="alsa dbus gif gpm gtk gzip-el hesiod jpeg kerberos libotf motif png spell sound source svg tiff toolkit-scroll-bars X Xaw3d xft xpm"
RESTRICT="strip"

RDEPEND="sys-libs/ncurses
	>=app-admin/eselect-emacs-1.2
	net-libs/liblockfile
	hesiod? ( net-dns/hesiod )
	kerberos? ( virtual/krb5 )
	spell? ( || ( app-text/ispell app-text/aspell ) )
	alsa? ( media-libs/alsa-lib )
	gpm? ( sys-libs/gpm )
	dbus? ( sys-apps/dbus )
	X? (
		x11-libs/libXmu
		x11-libs/libXt
		x11-misc/xbitmaps
		x11-misc/emacs-desktop
		gif? ( media-libs/giflib )
		jpeg? ( media-libs/jpeg )
		png? ( media-libs/libpng )
		svg? ( >=gnome-base/librsvg-2.0 )
		tiff? ( media-libs/tiff )
		xpm? ( x11-libs/libXpm )
		xft? (
			media-libs/fontconfig
			media-libs/freetype
			virtual/xft
			libotf? ( >=dev-libs/libotf-0.9.4 )
		)
		gtk? ( =x11-libs/gtk+-2* )
		!gtk? (
			Xaw3d? ( x11-libs/Xaw3d )
			!Xaw3d? (
				motif? ( virtual/motif )
			)
		)
	)"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	gzip-el? ( app-arch/gzip )"

S="${WORKDIR}/${ECVS_LOCALNAME}"

EMACS_SUFFIX="emacs-${SLOT}"

src_unpack() {
	cvs_src_unpack

	cd "${S}"
	# FULL_VERSION keeps the full version number, which is needed in
	# order to determine some path information correctly for copy/move
	# operations later on
	FULL_VERSION=$(grep 'defconst[	 ]*emacs-version' lisp/version.el \
		| sed -e 's/^[^"]*"\([^"]*\)".*$/\1/')
	[ "${FULL_VERSION}" ] || die "Cannot determine current Emacs version"
	echo
	einfo "Emacs CVS branch: ${ECVS_BRANCH}"
	einfo "Emacs version number: ${FULL_VERSION}"
	[ "${FULL_VERSION}" = ${PV} ] \
		|| die "Upstream version number changed to ${FULL_VERSION}"
	echo

	epatch "${FILESDIR}/${PN}-freebsd-sparc.patch"

	sed -i -e "s:/usr/lib/crtbegin.o:$(`tc-getCC` -print-file-name=crtbegin.o):g" \
		-e "s:/usr/lib/crtend.o:$(`tc-getCC` -print-file-name=crtend.o):g" \
		"${S}"/src/s/freebsd.h || die "unable to sed freebsd.h settings"

	if ! use alsa; then
		# ALSA is detected even if not requested by its USE flag.
		# Suppress it by supplying pkg-config with a wrong library name.
		sed -i -e "/ALSA_MODULES=/s/alsa/DiSaBlEaLsA/" configure.in \
			|| die "unable to sed configure.in"
	fi
	if ! use gzip-el; then
		# Emacs' build system automatically detects the gzip binary and
		# compresses el files. We don't want that so confuse it with a
		# wrong binary name
		sed -i -e "s/ gzip/ PrEvEnTcOmPrEsSiOn/" configure.in \
			|| die "unable to sed configure.in"
	fi

	eautoreconf
}

src_compile() {
	export SANDBOX_ON=0			# for the unbelievers, see Bug #131505
	ALLOWED_FLAGS=""
	strip-flags
	unset LDFLAGS
	replace-flags -O[3-9] -O2

	local myconf

	if use alsa && ! use sound; then
		echo
		einfo "Although sound USE flag is disabled you chose to have alsa,"
		einfo "so sound is switched on anyway."
		echo
		myconf="${myconf} --with-sound"
	else
		myconf="${myconf} $(use_with sound)"
	fi

	if use X; then
		myconf="${myconf} --with-x"
		myconf="${myconf} $(use_with toolkit-scroll-bars)"
		myconf="${myconf} $(use_with gif) $(use_with jpeg)"
		myconf="${myconf} $(use_with png) $(use_with svg rsvg)"
		myconf="${myconf} $(use_with tiff) $(use_with xpm)"

		myconf="${myconf} $(use_enable xft font-backend)"
		myconf="${myconf} $(use_with xft freetype) $(use_with xft)"
		if use xft && use libotf; then
			# disable m17n-flt since m17n-lib-1.3.4 doesn't support it
			myconf="${myconf} --with-libotf --without-m17n-flt"
		else
			myconf="${myconf} --without-libotf --without-m17n-flt"
		fi

		# GTK+ is the default toolkit if USE=gtk is chosen with other
		# possibilities. Emacs upstream thinks this should be standard
		# policy on all distributions
		if use gtk; then
			einfo "Configuring to build with GTK+ support, disabling all other toolkits"
			myconf="${myconf} --with-x-toolkit=gtk"
		elif use Xaw3d; then
			einfo "Configuring to build with Xaw3d (athena) support"
			myconf="${myconf} --with-x-toolkit=athena"
		elif use motif; then
			einfo "Configuring to build with motif toolkit support"
			myconf="${myconf} --with-x-toolkit=motif"
		else
			einfo "Configuring to build with no toolkit"
			myconf="${myconf} --with-x-toolkit=no"
		fi
	else
		myconf="${myconf} --without-x"
	fi

	myconf="${myconf} $(use_with hesiod)"
	myconf="${myconf} $(use_with kerberos) $(use_with kerberos kerberos5)"
	myconf="${myconf} $(use_with gpm) $(use_with dbus)"

	econf \
		--program-suffix=-${EMACS_SUFFIX} \
		--infodir=/usr/share/info/${EMACS_SUFFIX} \
		--without-carbon \
		${myconf} || die "econf emacs failed"

	emake CC="$(tc-getCC)" bootstrap || die "make bootstrap failed"
}

src_install () {
	local i m

	emake install DESTDIR="${D}" || die "make install failed"

	rm "${D}"/usr/bin/emacs-${FULL_VERSION}-${EMACS_SUFFIX} \
		|| die "removing duplicate emacs executable failed"
	mv "${D}"/usr/bin/emacs-${EMACS_SUFFIX} "${D}"/usr/bin/${EMACS_SUFFIX} \
		|| die "moving Emacs executable failed"

	# move info documentation to the correct place
	einfo "Fixing info documentation ..."
	for i in "${D}"/usr/share/info/${EMACS_SUFFIX}/*; do
		mv "${i}" "${i}.info" || die "mv info failed"
	done

	# move man pages to the correct place
	einfo "Fixing manpages ..."
	for m in "${D}"/usr/share/man/man1/* ; do
		mv "${m}" "${m%.1}-${EMACS_SUFFIX}.1" || die "mv man failed"
	done

	# avoid collision between slots, see bug #169033 e.g.
	rm "${D}"/usr/share/emacs/site-lisp/subdirs.el
	rm -rf "${D}"/usr/share/{applications,icons}
	rm "${D}"/var/lib/games/emacs/{snake,tetris}-scores
	keepdir /var/lib/games/emacs/

	if use source; then
		insinto /usr/share/emacs/${FULL_VERSION}/src
		# This is not meant to install all the source -- just the
		# C source you might find via find-function
		doins src/*.[ch]
		sed 's/^X//' >10${PN}-${SLOT}-gentoo.el <<-EOF

		;;; ${PN}-${SLOT} site-lisp configuration

		(if (string-match "\\\\\`${FULL_VERSION//./\\\\.}\\\\>" emacs-version)
		X    (setq find-function-C-source-directory
		X	  "/usr/share/emacs/${FULL_VERSION}/src"))
		EOF
		elisp-site-file-install 10${PN}-${SLOT}-gentoo.el
	fi

	dodoc README README.unicode BUGS || die "dodoc failed"
}

emacs-infodir-rebuild() {
	# Depending on the Portage version, the Info dir file is compressed
	# or removed. It is only rebuilt by Portage if our directory is in
	# INFOPATH, which is not guaranteed. So we rebuild it ourselves.

	local infodir=/usr/share/info/${EMACS_SUFFIX} f
	einfo "Regenerating Info directory index in ${infodir} ..."
	rm -f "${ROOT}"${infodir}/dir{,.*}
	for f in "${ROOT}"${infodir}/*.info*; do
		[[ ${f##*/} == *[0-9].info* ]] \
			|| install-info --info-dir="${ROOT}"${infodir} "${f}" &>/dev/null
	done
	rmdir "${ROOT}"${infodir} 2>/dev/null # remove dir if it is empty
	echo
}

pkg_postinst() {
	test -f "${ROOT}"/usr/share/emacs/site-lisp/subdirs.el ||
		cp "${ROOT}"/usr/share/emacs{/${FULL_VERSION},}/site-lisp/subdirs.el

	local f
	for f in "${ROOT}"/var/lib/games/emacs/{snake,tetris}-scores; do
		test -e "${f}" || touch "${f}"
	done

	elisp-site-regen
	emacs-infodir-rebuild
	eselect emacs update ifunset

	if use X; then
		elog "You need to install some fonts for Emacs. Under monolithic"
		elog "XFree86/Xorg you typically had such fonts installed by default."
		elog "With modular Xorg, you will have to perform this step yourself."
		elog "Installing media-fonts/font-adobe-{75,100}dpi on the X server's"
		elog "machine would satisfy basic Emacs requirements under X11."
	fi

	echo
	elog "You can set the version to be started by /usr/bin/emacs through"
	elog "the Emacs eselect module, which also redirects man and info pages."
	elog "You can therefore test emacs-cvs along with the stable release."
	elog "\"man emacs.eselect\" for details."
}

pkg_postrm() {
	elisp-site-regen
	emacs-infodir-rebuild
	eselect emacs update ifunset
}
