# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dbxml/dbxml-2.5.16.ebuild,v 1.1 2010/01/19 09:28:44 dev-zero Exp $

EAPI="2"

inherit autotools flag-o-matic perl-app python eutils versionator libtool multilib java-pkg-opt-2

MY_PV="$(get_version_component_range 1-3)"
MY_P="${PN}-${MY_PV}"
PATCH_V="$(get_version_component_range 4)"
PATCH_V="${PATCH_V:-0}"
DB_VER="4.8"

DESCRIPTION="BerkeleyDB XML, a native XML database from the BerkeleyDB team"
HOMEPAGE="http://www.oracle.com/database/berkeley-db/xml/index.html"
SRC_URI="http://download-east.oracle.com/berkeley-db/${MY_P}.tar.gz
	http://download-west.oracle.com/berkeley-db/${MY_P}.tar.gz
	http://download-uk.oracle.com/berkeley-db/${MY_P}.tar.gz"
LICENSE="OracleDB Apache-1.1 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples java perl python tcl"

RDEPEND="sys-libs/db:${DB_VER}[-nocxx,java?]
	>=dev-libs/xerces-c-3
	>=dev-libs/xqilla-2.1.2
	sys-libs/zlib
	perl? ( dev-lang/perl )
	python? (
		dev-lang/python:2.6
		>=dev-python/bsddb3-4.8.0 )
	tcl? ( dev-lang/tcl )
	java? ( >=virtual/jre-1.5 )"
DEPEND="${RDEPEND}
	sys-devel/libtool
	java? ( >=virtual/jdk-1.5 )"

get_patches() {
	local patches=""
	local patch_v=1
	while [ ${patch_v} -le ${PATCH_V} ] ; do
		patches="${patches} patch.${MY_PV}.${patch_v}"
		let "patch_v = ${patch_v} + 1"
	done
	echo ${patches}
}

for patch in $(get_patches) ; do
	SRC_URI="${SRC_URI}
		http://www.oracle.com/technology/products/berkeley-db/xml/update/${MY_PV}/${patch}"
done

S="${WORKDIR}/${MY_P}/dbxml"

src_unpack() {
	tar xzpf "${DISTDIR}/${MY_P}.tar.gz" ${MY_P}/dbxml || die "unpacking package failed"
}

src_prepare() {
	for patch in $(get_patches) ; do
		edos2unix "${DISTDIR}/${patch}"
		epatch "${DISTDIR}/${patch}"
	done

	# sys-libs/db is slotted on Gentoo
	sed -i \
		-e "s:db_version=.*:db_version=${DB_VER}:" \
		dist/aclocal/options.ac configure || die "sed failed"

	if use java ; then
		sed -i \
			-e "s|\$with_berkeleydb/lib/db.jar|$(java-pkg_getjars db-${DB_VER})|" \
			dist/aclocal/options.ac configure || die "sed failed"
	fi

	# * Fix libraries to link
	# * Strip "../../build_unix/.libs" from LIBPATH or it'll
	#   show up in the RPATH entry
	sed -i \
		-e "s|dbxml-2|dbxml-$(get_version_component_range 1-2)|" \
		-e "s|db-4|db-${DB_VER}|" \
		-e 's|dbxml_home = .*|dbxml_home = "../.."|' \
		-e 's|"../../build_unix/.libs",||' \
		src/python/setup.py.in || die "sed failed"

	sed -i \
		-e "s|dbxml-2|dbxml-$(get_version_component_range 1-2)|" \
		-e "s|db_cxx-4|db_cxx-${DB_VER}|" \
		-e "s|@DB_DIR@/lib|/usr/$(get_libdir)|" \
		-e "s|@DB_DIR@/include|/usr/include/db${DB_VER}|" \
		-e "s|@XERCES_DIR@/lib|/usr/$(get_libdir)|" \
		-e "s|@XQILLA_DIR@/lib|/usr/$(get_libdir)|" \
		src/perl/config.in || die "sed failed"

	# avoid the automake/autoconf run in src_{configure,compile}
	ln -sf /usr/share/libtool/config/ltmain.sh dist/ltmain.sh || die "replacing ltmain.sh failed"
	elibtoolize
	autoreconf
}

src_configure() {
	cd "${S}/build_unix"

	#Needed despite db_version stuff above
	append-flags -I/usr/include/db${DB_VER}

	local myconf=""

	# use_enable doesn't work here due to a different syntax
	use java && myconf="${myconf} --enable-java"
	use tcl && myconf="${myconf} --enable-tcl --with-tcl=/usr/$(get_libdir)"

	export ac_cv_prog_path_strip="missing_strip"
	ECONF_SOURCE="../" \
	JAVAPREFIX="${JAVA_HOME}" \
		econf \
			--with-berkeleydb=/usr \
			--with-xqilla=/usr \
			--with-xerces=/usr \
			${myconf}
}

src_compile() {
	cd "${S}/build_unix"

	default

	if use python ; then
		einfo "Compiling python extension"
		cd "${S}/src/python"
		append-cflags "-I../../include"
		append-ldflags "-L../../build_unix/.libs"
		python_version
		"${python}" setup.py build || die "python build failed"
	fi

	if use perl ; then
		cd "${S}/src/perl"
		perl-app_src_prep
		perl-app_src_compile
	fi
}

src_install() {
	cd "${S}/build_unix"

	# somewhat broken build system
	emake DESTDIR="${D}" install || die "emake install failed"

	use doc && dohtml -A pdf -r "${D}"/usr/docs/*
	rm -rf "${D}/usr/docs"

	if use java ; then
		java-pkg_dojar "${D}/usr/$(get_libdir)/dbxml.jar"
		rm "${D}/usr/$(get_libdir)/dbxml.jar"
	fi

	if use python ; then
		cd "${S}/src/python"
		python_version
		"${python}" setup.py install --root="${D}" --no-compile || die "python install failed"
		python_need_rebuild
	fi

	if use perl ; then
		cd "${S}/src/perl"
		emake DESTDIR="${D}" install || die "emake install perl module failed"
		fixlocalpod
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r "${S}/examples"
	fi

}

pkg_preinst() {
	perl-module_pkg_preinst
	java-pkg-opt-2_pkg_preinst
}

pkg_postinst() {
	if use python ; then
		python_version
		python_mod_optimize "/usr/$(get_libdir)/python${PYVER}/site-packages"
	fi
}

pkg_postrm() {
	if use python ; then
		python_version
		python_mod_cleanup "/usr/$(get_libdir)/python${PYVER}/site-packages"
	fi
}
