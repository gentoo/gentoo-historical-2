# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/db/db-4.3.29.ebuild,v 1.7 2006/06/12 08:37:37 pauldv Exp $

inherit eutils gnuconfig db flag-o-matic

#Number of official patches
#PATCHNO=`echo ${PV}|sed -e "s,\(.*_p\)\([0-9]*\),\2,"`
PATCHNO=${PV/*.*.*_p}
if [ "${PATCHNO}" == "${PV}" ]; then
	MY_PV=${PV}
	MY_P=${P}
	PATCHNO=0
else
	MY_PV=${PV/_p${PATCHNO}}
	MY_P=${PN}-${MY_PV}
fi

S=${WORKDIR}/${MY_P}/build_unix
DESCRIPTION="Berkeley DB"
HOMEPAGE="http://www.sleepycat.com/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
#SRC_URI="ftp://ftp.sleepycat.com/releases/${MY_P}.tar.gz"
for (( i=1 ; i<=$PATCHNO ; i++ )) ; do
	export SRC_URI="${SRC_URI} http://www.sleepycat.com/update/${MY_PV}/patch.${MY_PV}.${i}"
done

LICENSE="DB"
SLOT="4.3"
KEYWORDS="~amd64 ~ia64 ~m68k ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="tcltk java doc nocxx bootstrap"

DEPEND="tcltk? ( >=dev-lang/tcl-8.4 )
	java? ( virtual/jdk )
	>=sys-devel/binutils-2.16.1"
RDEPEND="tcltk? ( dev-lang/tcl )
	java? ( virtual/jre )"

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd ${WORKDIR}/${MY_P}
	for (( i=1 ; i<=$PATCHNO ; i++ ))
	do
		epatch ${DISTDIR}/patch.${MY_PV}.${i}
	done
	epatch ${FILESDIR}/${PN}-${SLOT}-jarlocation.patch
	epatch ${FILESDIR}/${PN}-${SLOT}-libtool.patch

	epatch ${FILESDIR}/${PN}-4.3.27-fix-dep-link.patch

	gnuconfig_update "${S}/../dist"

	sed -i -e "s,\(ac_compiler\|\${MAKEFILE_CC}\|\${MAKEFILE_CXX}\|\$CC\)\( *--version\),\1 -dumpversion,g" ${S}/../dist/configure
}

src_compile() {
	addwrite /proc/self/maps

	local myconf=""

	use amd64 && myconf="${myconf} --with-mutex=x86/gcc-assembly"

	use bootstrap \
		&& myconf="${myconf} --disable-cxx" \
		|| myconf="${myconf} $(use_enable !nocxx cxx)"

	use tcltk \
		&& myconf="${myconf} --enable-tcl --with-tcl=/usr/$(get_libdir)" \
		|| myconf="${myconf} --disable-tcl"

	myconf="${myconf} $(use_enable java)"
	if use java && [[ -n ${JAVAC} ]] ; then
		export PATH=`dirname ${JAVAC}`:${PATH}
		export JAVAC=`basename ${JAVAC}`
	fi

	[[ -n ${CBUILD} ]] && myconf="${myconf} --build=${CBUILD}"

	# the entire testsuite needs the TCL functionality
	if use tcltk && has test $FEATURES ; then
		myconf="${myconf} --enable-test"
	else
		myconf="${myconf} --disable-test"
	fi

	# Add linker versions to the symbols. Easier to do, and safer than header file
	# mumbo jumbo.
	if use userland_GNU; then
		append-ldflags -Wl,--default-symver
	fi

	../dist/configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--libdir=/usr/$(get_libdir) \
		--enable-compat185 \
		--without-uniquename \
		--enable-rpc \
		--host=${CHOST} \
		${myconf} || die "configure failed"

	emake -j1 || die "make failed"
}

src_install() {
	einstall libdir="${D}/usr/$(get_libdir)" strip="${D}/bin/strip" || die

	db_src_install_usrbinslot

	db_src_install_headerslot

	db_src_install_doc

	db_src_install_usrlibcleanup

	dodir /usr/sbin
	mv ${D}/usr/bin/berkeley_db_svc ${D}/usr/sbin/berkeley_db43_svc

	if use java; then
		mkdir -p ${D}/usr/share/db
		cat <<EOF >${D}/usr/share/db/package.env
DESCRIPTION=The java bindings for berkeley db version ${MY_PV}
CLASSPATH=:/usr/lib/db-${SLOT}.jar
EOF
	fi
}

pkg_postinst () {
	db_fix_so
}

pkg_postrm () {
	db_fix_so
}
