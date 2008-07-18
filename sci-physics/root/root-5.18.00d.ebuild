# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/root/root-5.18.00d.ebuild,v 1.3 2008/07/18 09:19:35 bicatali Exp $

EAPI="1"
inherit versionator flag-o-matic eutils toolchain-funcs qt3 qt4 fortran

#DOC_PV=$(get_major_version)_$(get_version_component_range 2)
DOC_PV=5_16

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
SRC_URI="ftp://root.cern.ch/${PN}/${PN}_v${PV}.source.tar.gz
	doc? ( ftp://root.cern.ch/root/doc/Users_Guide_${DOC_PV}.pdf )"
HOMEPAGE="http://root.cern.ch/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"

IUSE="afs cern doc fftw kerberos ldap +math mysql odbc
	pch postgres python ruby qt3 qt4 ssl +truetype xml xrootd"

# libafterimage ignored, may be re-install for >=5.20
# see https://savannah.cern.ch/bugs/?func=detailitem&item_id=30944
#	|| ( >=media-libs/libafterimage-1.15 x11-wm/afterstep )
RDEPEND="sys-apps/shadow
	x11-libs/libXpm
	media-libs/ftgl
	dev-libs/libpcre
	virtual/opengl
	virtual/glu
	math? ( >=sci-libs/gsl-1.8 )
	afs? ( >=net-fs/openafs-1.4.7 )
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-server )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	qt3? ( !qt4? ( $(qt_min_version 3.3.4) ) )
	qt4? ( || ( >=x11-libs/qt-4.3:4
				( x11-libs/qt-gui:4
				  x11-libs/qt-opengl:4
				  x11-libs/qt-qt3support:4
				  x11-libs/qt-xml:4 ) ) )
	fftw? ( >=sci-libs/fftw-3 )
	python? ( dev-lang/python )
	ruby? ( dev-lang/ruby )
	ssl? ( dev-libs/openssl )
	xml? ( dev-libs/libxml2 )
	cern? ( sci-physics/cernlib )
	odbc? ( dev-db/unixODBC )
	truetype? ( x11-libs/libXft )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${PN}"

QT4_BUILT_WITH_USE_CHECK="qt3support opengl"

pkg_setup() {
	elog
	elog "You may want to build ROOT with these non Gentoo extra packages:"
	elog "AliEn, castor, Chirp, clarens, gfal, Globus, GEANT4, Monalisa, "
	elog "Oracle, peac, PYTHIA, PYTHIA6, SapDB, SRP, Venus"
	elog "You can use the env variable EXTRA_ECONF variable for this."
	elog "Example, for PYTHIA, you would do: "
	elog "EXTRA_ECONF=\"--enable-pythia --with-pythia-libdir=/usr/$(get_libdir)\""
	elog
	epause 7
	if use cern; then
		FORTRAN="gfortran g77 ifc"
		fortran_pkg_setup
	fi
	use qt4 && qt4_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-pic.patch
	epatch "${FILESDIR}"/${PN}-5.16.00-xft.patch
	epatch "${FILESDIR}"/${P}-gcc43.patch
	epatch "${FILESDIR}"/${P}-makefile.patch
	cd xrootd/src
	local xp=xrootd-20071116
	tar xfz ${xp}-0000.src.tgz
	epatch "${FILESDIR}"/${xp}-checksymbol.patch
	epatch "${FILESDIR}"/${xp}-gcc43.patch
	tar cfz ${xp}-0000.src.tgz xrootd
}

src_compile() {

	local target
	if [[ "$(tc-getCXX)" == icc* ]]; then
		if use amd64; then
			target=linuxx8664icc
		elif use x86; then
			target=linuxicc
		fi
	fi

	#local myfortran
	#use cern && \
	#	myfortran="${FORTRANC} ${FFLAGS}"
	local myconf
	use postgres && \
		myconf="--with-pgsql-incdir=/usr/include/postgresql"

	if use qt3 || use qt4; then
		myconf="${myconf} --enable-qt --enable-qtgsi"
	else
		myconf="${myconf} --disable-qt --disable-qtgsi"
	fi
	use qt4 && \
		myconf="${myconf} --with-qt-incdir=/usr/include/qt4" && \
		myconf="${myconf} --with-qt-libdir=/usr/$(get_libdir)/qt4"

	use qt3 && ! use qt4 && \
		myconf="${myconf} --with-qt-incdir=/usr/qt/3/include" && \
		myconf="${myconf} --with-qt-libdir=/usr/qt/3/$(get_libdir)"

	# watch: the configure script is not the standard autotools
	local docdir=/usr/share/doc/${PF}
	./configure \
		${target} \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir)/${PN} \
		--docdir=${docdir} \
		--disable-builtin-afterimage \
		--disable-builtin-freetype \
		--disable-builtin-ftgl \
		--disable-builtin-pcre \
		--disable-builtin-zlib \
		--enable-asimage \
		--enable-astiff \
		--enable-cintex \
		--enable-exceptions	\
		--enable-explicitlink \
		--enable-gdml \
		--enable-opengl \
		--enable-reflex \
		--enable-shadowpw \
		--enable-shared	\
		--enable-soversion \
		--enable-table \
		${myconf} \
		$(use_enable afs) \
		$(use_enable cern) \
		$(use_enable fftw fftw3) \
		$(use_enable kerberos krb5) \
		$(use_enable ldap) \
		$(use_enable math mathcore) \
		$(use_enable math mathmore) \
		$(use_enable math minuit2) \
		$(use_enable math roofit) \
		$(use_enable math unuran) \
		$(use_enable mysql) \
		$(use_enable odbc) \
		$(use_enable pch) \
		$(use_enable postgres pgsql) \
		$(use_enable python) \
		$(use_enable ruby) \
		$(use_enable ssl) \
		$(use_enable truetype xft) \
		$(use_enable xml) \
		$(use_enable xrootd) \
		${EXTRA_ECONF} \
		|| die "configure failed"

	local myfortran
	use cern && myfortran="F77=${FORTRANC}"
	emake \
		OPT="${CXXFLAGS}" \
		OPTFLAGS="${CXXFLAGS}" \
		${myfortran} \
		|| die "emake failed"
	emake cintdlls || die "emake cintdlls failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	echo "LDPATH=/usr/$(get_libdir)/root" > 99root
	use python && echo "PYTHONPATH=/usr/$(get_libdir)/root" >> 99root
	doenvd 99root || die "doenvd failed"

	if use doc; then
		einfo "Installing user's guide and ref manual"
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/Users_Guide_${DOC_PV}.pdf \
			|| die "pdf install failed"
	fi
}
