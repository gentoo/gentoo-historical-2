# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/povray/povray-3.7.0_beta29-r1.ebuild,v 1.1 2008/11/08 21:45:38 lavajoe Exp $

inherit eutils autotools flag-o-matic versionator

MAJOR_VER=$(get_version_component_range 1-3)
MINOR_VER=$(get_version_component_range 4)
if [ -n "$MINOR_VER" ]; then
	MINOR_VER=${MINOR_VER/beta/beta.}
	MY_PV="${MAJOR_VER}.${MINOR_VER}"
else
	MY_PV=${MAJOR_VER}
fi

DESCRIPTION="The Persistence of Vision Raytracer"
HOMEPAGE="http://www.povray.org/"
SRC_URI="http://www.povray.org/beta/source/${PN}-src-${MY_PV}.tar.bz2"

LICENSE="povlegal-3.6"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="svga tiff X"

DEPEND="media-libs/libpng
	tiff? ( >=media-libs/tiff-3.6.1 )
	media-libs/jpeg
	sys-libs/zlib
	X? ( x11-libs/libXaw )
	svga? ( media-libs/svgalib )
	>=dev-libs/boost-1.33"

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Print info on how to extend the expiration date of the beta
	# if it has expired.
	epatch "${FILESDIR}"/${PN}-${MAJOR_VER}-print-extend-expiration-info.patch

	# Change some destination directories that cannot be adjusted via configure
	cp configure.ac configure.ac.orig
	sed -i -e 's:${povsysconfdir}/$PACKAGE/$VERSION_BASE:${povsysconfdir}/'${PN}':g' configure.ac
	sed -i -e 's:${povdatadir}/$PACKAGE-$VERSION_BASE:${povdatadir}/'${PN}':g' configure.ac
	sed -i -e 's:${povdatadir}/doc/$PACKAGE-$VERSION_BASE:${povdatadir}/doc/'${PF}':g' configure.ac

	cp Makefile.am Makefile.am.orig
	sed -i -e "s:^povlibdir = .*:povlibdir = @datadir@/${PN}:" Makefile.am
	sed -i -e "s:^povdocdir = .*:povdocdir = @datadir@/doc/${PF}:" Makefile.am
	sed -i -e "s:^povconfdir = .*:povconfdir = @sysconfdir@/${PN}:" Makefile.am

	eautoreconf
}

src_compile() {
	# Fixes bug 71255
	if [[ $(get-flag march) == k6-2 ]]; then
		filter-flags -fomit-frame-pointer
	fi

	# The config files are installed correctly (e.g. povray.conf),
	# but the code compiles using incorrect [default] paths
	# (based on /usr/local...), so povray will not find the system
	# config files without the following fix:
	append-flags -DPOVLIBDIR=\\\"${ROOT}usr/share/${PN}\\\"
	append-flags -DPOVCONFDIR=\\\"${ROOT}etc/${PN}\\\"

	econf \
		COMPILED_BY="Portage (Gentoo `uname`) on `hostname -f`" \
		$(use_with svga) \
		$(use_with tiff) \
		$(use_with X) \
		--disable-strip \
		|| die

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_preinst() {
	# Copy the old config files if they are in the old location
	# but do not yet exist in the new location.
	# This way, they can be treated by CONFIG_PROTECT as normal.
	for conf_file in $(ls "${D}/etc/${PN}"); do
		if [ ! -e "${ROOT}etc/${PN}/${conf_file}" ]; then
			for version_dir in $(ls "${ROOT}etc/${PN}" | grep "^[0-9]" | sort -rn); do
				if [ -e "${ROOT}etc/${PN}/${version_dir}/${conf_file}" ]; then
					mv "${ROOT}etc/${PN}/${version_dir}/${conf_file}" "${ROOT}etc/${PN}"
					elog "Note: ${conf_file} moved from ${ROOT}etc/povray/${version_dir}/ to ${ROOT}etc/povray/"
					break
				fi
			done
		fi
	done
}

pkg_postinst() {
	ewarn "POV-Ray betas have expiration dates, but these can be extended for up to"
	ewarn "a year.  If expired, you will get the following error when running povray:"
	ewarn
	ewarn "    povray: this pre-release version of POV-Ray for Unix has expired"
	ewarn
	ewarn "To extend the license period (a week at a time), you can do"
	ewarn "something like the following (adjust syntax for your shell):"
	ewarn
	ewarn "    export POVRAY_BETA=\`povray --betacode 2>&1\`"
	ewarn
	ewarn "You will need to repeat this each time it expires."
}
