# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdbc3-oracle/jdbc3-oracle-9.2.0.1.ebuild,v 1.7 2004/06/24 22:32:35 agriffis Exp $

inherit java-pkg

S=${WORKDIR}
DESCRIPTION="JDBC 3.0 Drivers for Oracle"
SRC_URI=""
HOMEPAGE="http://otn.oracle.com/software/tech/java/sqlj_jdbc/htdocs/jdbc9201.html"
KEYWORDS="x86 sparc"
LICENSE="oracle-jdbc"
SLOT="1"
DEPEND=">=app-arch/unzip-5.50-r1"
RDEPEND=">=virtual/jdk-1.4"
IUSE="debug doc"

use debug && DISTFILE1=ojdbc14_g.jar || DISTFILE1=ojdbc14.jar
DISTFILE2=ocrs12.zip
DISTFILE3=javadoc.zip
FILE1=${P}-${DISTFILE1}
FILE2=${P}-${DISTFILE2}
FILE3=${P}-${DISTFILE3}

src_unpack() {
	# Build File List
	FILELIST="${FILE1} ${FILE2}"
	use doc > /dev/null && FILELIST="${FILELIST} ${FILE3}"

	# Check for distributables
	echo " "
	for i in ${FILELIST} ; do
		if [ ! -f ${DISTDIR}/${i} ] ; then
			echo "!!! MISSING FILE: ${DISTDIR}/${i}"
			MISSING_FILES="true"
		else
			cp ${DISTDIR}/${i} ${S}
		fi
	done
	echo " "


	if [ "${MISSING_FILES}" == "true" ] ; then
		einfo " "
		einfo " Because of license terms and file name conventions, please:"
		einfo " "
		einfo " 1. Visit ${HOMEPAGE}"
		einfo "    (you may need to create an account on Oracle's site)"
		einfo " 2. Download the appropriate files:"
		einfo "    2a. ${DISTFILE1}"
		einfo "    2b. ${DISTFILE2}"
		use doc > /dev/null && einfo "    2c. ${DISTFILE3}"
		einfo " 3. Rename the files:"
		einfo "    3a. ${DISTFILE1} ---> ${FILE1}"
		einfo "    3b. ${DISTFILE2} ---> ${FILE2}"
		use doc > /dev/null && einfo "    3c. ${DISTFILE3} ---> ${FILE4}"
		einfo " 4. Place the files in ${DISTDIR}"
		einfo " 5. Repeat the emerge process to continue."
		einfo " "
		die "User must manually fetch/rename files"
	fi

	# Move files back to their original filenames
	mv ${S}/${FILE1} ${S}/${DISTFILE1}
	mv ${S}/${FILE2} ${S}/${DISTFILE2}
	use doc && mv ${S}/${FILE3} ${S}/${DISTFILE3}
}

src_compile() {
	einfo " This is a binary-only (bytecode) ebuild."
}

src_install() {
	if use doc ; then
		mkdir ${S}/javadoc
		cd ${S}/javadoc
		unzip ${DISTDIR}/${FILE3}
		dohtml -r ${S}/javadoc/
	fi
	java-pkg_dojar ${S}/*.zip
	java-pkg_dojar ${S}/*.jar
}

