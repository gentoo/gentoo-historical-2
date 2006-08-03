# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/db/db-4.2.52_p4.ebuild,v 1.6 2006/08/03 23:46:04 cardoe Exp $

inherit eutils gnuconfig db

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
for (( i=1 ; i<=$PATCHNO ; i++ )) ; do
	export SRC_URI="${SRC_URI} http://www.sleepycat.com/update/${MY_PV}/patch.${MY_PV}.${i}"
done

LICENSE="DB"
SLOT="4.2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="tcl java doc nocxx bootstrap"

DEPEND="tcl? ( >=dev-lang/tcl-8.4 )
	java? ( virtual/jdk )"
RDEPEND="tcl? ( dev-lang/tcl )
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
	epatch ${FILESDIR}/${PN}-4.0.14-fix-dep-link.patch
	epatch ${FILESDIR}/${PN}-4.2.52_p2-TXN.patch

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

	use tcl \
		&& myconf="${myconf} --enable-tcl --with-tcl=/usr/$(get_libdir)" \
		|| myconf="${myconf} --disable-tcl"

	myconf="${myconf} $(use_enable java)"
	if use java && [[ -n ${JAVAC} ]] ; then
		export PATH=`dirname ${JAVAC}`:${PATH}
		export JAVAC=`basename ${JAVAC}`
	fi

	[[ -n ${CBUILD} ]] && myconf="${myconf} --build=${CBUILD}"

	# the entire testsuite needs the TCL functionality
	if use tcl && has test $FEATURES; then
		myconf="${myconf} --enable-test"
	else
		myconf="${myconf} --disable-test"
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
		--with-uniquename \
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
	mv ${D}/usr/bin/berkeley_db_svc ${D}/usr/sbin/berkeley_db42_svc

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
